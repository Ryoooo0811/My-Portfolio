class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about]

  # ログイン後にヘッダーにユーザー名を表示させる
  before_action :get_current_user
  def get_current_user
    @user = current_user
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_up_path_for(resource)
    user_path(current_user)
  end

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
