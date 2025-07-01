class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper ApplicationHelper
  after_action :store_location

  def store_location
      if (request.fullpath != "/users/sign_in" && \
          request.fullpath != "/users/sign_up" && \
          request.fullpath != "/users/password" && \
          !request.xhr?) # don't store ajax calls
        session[:previous_url] = request.fullpath
      end
  end

  #ログイン後のリダイレクトをログイン前のページにする
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
