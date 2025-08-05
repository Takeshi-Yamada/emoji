class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show, :edit, :update, :calendar ]

  def show
    @questions = @user.questions
    @answers = @user.answers.includes(:question).order(created_at: :desc).page(params[:page])
  end

  def edit; end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: "プロフィールを更新しました"
    else
      flash.now[:danger] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def calendar
    first_day = Date.current.beginning_of_month
    last_day = Date.current.end_of_month

    # 日曜日始まり（wday: 0）で整列させている
    beginning_of_calendar = first_day.beginning_of_week(:sunday)
    end_of_calendar = last_day.end_of_week(:sunday)

    @range = beginning_of_calendar..end_of_calendar
    @login_days = current_user.login_histories
                              .where(logged_in_on: @range)
                              .pluck(:logged_in_on)
                              .map(&:to_date)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def set_user
    @user = User.find(current_user[:id])
  end
end
