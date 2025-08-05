class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :record_login_history
  helper ApplicationHelper
  after_action :store_location

  def store_location
      if request.fullpath != "/users/sign_in" && request.fullpath != "/users/sign_up" && request.fullpath != "/users/password" && !request.xhr?
        session[:previous_url] = request.fullpath
      end
  end

  # ログイン後のリダイレクトをログイン前のページにする
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  private

  # 今日初のアクションならログインレコードを作成する
  def record_login_history
    if user_signed_in? && session[:last_login_check_date] != Date.today.to_s
      LoginHistory.find_or_create_by(user: current_user, logged_in_on: Date.today)
      session[:last_login_check_date] = Date.today.to_s
    end
  end

  protected

  # deviseで追加のパラメーターを許可している
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end
end
