class QuestionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :authenticate_user!, only: [:new, :edit, :update]

  def index
    @questions = Question.includes(:user).order(created_at: :desc)
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to question_path(@question), success: '登録ができました'
    else
      flash.now[:error] = '登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @question = Question.find(params[:id])
    if user_signed_in?
      @answers = current_user.answers.where(question_id: params[:id])
      @already_correct = @answers.find { |a| a.result? }
      p @already_correct
    end
  end

  def edit
    @question = current_user.questions.find(params[:id])
  end

  def update
    @question = current_user.questions.find(params[:id])
    if @question.update(question_params)
      redirect_to question_path(@question), success: '編集が成功しました'
    else
      flash.now[:danger] = '更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    question = current_user.questions.find(params[:id])
    question.destroy!
    redirect_to questions_path, success: '削除に成功しました'
  end

  private

  def question_params
    params.require(:question).permit(:content, :correct, :hint_1, :hint_2, :hint_3)
  end

  def not_found
    redirect_back(fallback_location: root_path, alert: "対象のクイズが見つからないか、編集権限がありません。")
  end
end
