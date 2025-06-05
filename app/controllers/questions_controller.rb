class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to question_path, success: '登録ができました'
    else
      flash.now[:error] = '登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  def edit
    @question = current_user.questions.find(params[:id])
  end

  def update
    @question = current_user.questions.find(params[:id])
    if @question.update(question_params)
      redirect_to question_path(@question), success: '更新に成功しました'
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
    params.require(:question).permit(:content, :answer)
  end
end
