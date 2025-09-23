class QuestionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :authenticate_user!, only: [ :new, :edit, :update, :destroy, :restore ]
  before_action :set_question, only: [ :edit, :update, :destroy, :restore ]
  before_action :result_index, only: [ :index, :author ]

  def index
    @q = Question.active.ransack(params[:q])
    # タグ検索があれば優先
    if params[:tag_name].present?
      @questions = Question.active.tagged_with(params[:tag_name])
                            .includes(:user)
                            .order(created_at: :desc)
                            .page(params[:page])
      @searched_tag = params[:tag_name]
    else
      @questions = @q.result(distinct: true)
                      .includes(:user)
                      .order(created_at: :desc)
                      .page(params[:page])
    end

    # クイズの順番をidのみ保存(DISTINCTのORDER_BY問題を回避)
    session[:question_ids] = @questions.pluck(:id, :created_at).map(&:first)

    # ランキング用データ
    set_ranking
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      OgpCreator.generate(@question)
      redirect_to question_path(@question), success: "登録ができました"
    else
      flash.now[:error] = "登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @question = Question.find(params[:id])

    # クイズ一覧から来た場合はその順番を保持
    ids = session[:question_ids] || []
    current_index = ids.index(@question.id)
    if current_index
      @prev_id = ids[current_index - 1] if current_index > 0
      @next_id = ids[current_index + 1] if current_index < ids.size - 1
    end

    if user_signed_in?
      @answers = current_user.answers.where(question_id: params[:id])
      @already_correct = @answers.find { |a| a.is_result? }
    end
    # 初正解or不正解orギブアップのフラグ（answer#createからredirect時に発生）
    @first_correct = session.delete(:first_correct)
    @incorrect = session.delete(:incorrect)
    @just_give_up = session.delete(:just_give_up)
  end

  def edit; end

  def update
    if @question.update(question_params)
      OgpCreator.generate(@question)
      redirect_to question_path(@question), success: "編集が成功しました"
    else
      flash.now[:danger] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # レコード自体は削除せず、論理削除
    if @question.soft_delete
      redirect_to questions_path, success: "削除が成功しました"
    else
      redirect_to questions_path, alert: "削除に失敗しました"
    end
  end

  def restore
    if @question.restore
      redirect_to question_path(@question), notice: "復元しました"
    else
      redirect_to questions_path, alert: "復元に失敗しました"
    end
  end

  def give_up
    @question = Question.find(params[:id])
    if user_signed_in?
      current_user.give_ups.create(question: @question)
    else
      session[:gave_up] ||= {}
      session[:gave_up][@question.id] = true
    end
    session[:just_give_up] = true
    redirect_to @question
  end

  def generate_hint
    answer = params[:answer]
    result = QuizSupport.call(answer)
    render json: result
  end

  def author
    @question = Question.find(params[:id])
    @questions = Question.active.where(user_id: @question.user_id).order(created_at: :desc).page(params[:page])
    # ログインしている場合はレコードから、していない場合はセッションから正解・ギブアップ済みの問題IDを取得
    result_index
  end

  private

  def question_params
    params.require(:question).permit(:content, :correct, :tag_list, :hint_1, :hint_2, :hint_3)
  end

  def not_found
    redirect_back(fallback_location: root_path, alert: "対象のクイズが見つからないか、編集権限がありません。")
  end

  def set_question
    @question = current_user.questions.find(params[:id])
  end

  def set_ranking
    @question_ranking = Question.active.q_ranking
    @user_ranking = User.u_ranking
    @today_question = DailyQuestion.today_question
  end

  # 回答結果/ギブアップしている問題の取得
  def result_index
    # ログインしている場合はレコードから、していない場合はセッションから取得
    if user_signed_in?
        @correct_question_ids = current_user.answers.where(is_result: true).pluck(:question_id).uniq
        @gave_up_question_ids = current_user.give_ups.pluck(:question_id).uniq
    else
        @correct_question_ids = session[:correct]&.keys&.uniq&.map(&:to_i) || []
        @gave_up_question_ids = session[:gave_up]&.keys&.uniq&.map(&:to_i) || []
    end
  end
end
