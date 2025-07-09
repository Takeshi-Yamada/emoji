class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @answers = current_user.answers.find(params[:id])
  end

  def create
    @question = Question.find(params[:question_id])
    if user_signed_in?
      @answer = current_user.answers.build(question: @question, body: answer_params[:body], is_result: normalize(@question.correct) == normalize(answer_params[:body]))
      if @answer.save
        if @answer.is_result
          session[:first_correct] = true
        else
          session[:incorrect] = true
        end
      else
        flash.now[:alert] = "回答にエラーがあります"
        render "questions/show"
      end
    else
      @answer = Answer.new(question: @question, body: answer_params[:body], is_result: normalize(@question.correct) == normalize(answer_params[:body]))
      if @answer.is_result
        session[:answered] ||= {}
        session[:answered][@question.id] = true
        session[:first_correct] = true
      else
        #不正解のメッセージ
        session[:incorrect] = true
      end
    end
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def normalize(text)
    text.to_s.gsub(/[\s　]+/, "").gsub(/[[:punct:]\p{Punct}ー―〜…・！？!?,。、．「」『』（）()【】［］｛｝]/, "").tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z').downcase.tr('ァ-ン', 'ぁ-ん')
  end
end
