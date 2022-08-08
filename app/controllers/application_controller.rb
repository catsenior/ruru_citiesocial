class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound,with: :record_not_found
  before_action :find_categories, unless: :backend?
  helper_method :current_cart
  
  private

  def record_not_found
    render file: "#{Rails.root}/public/404.html",
           layout: false,
           status:404
  end

  def authenticate_admin
    unless current_user.admin?
      flash[:alert] = "Not allow!"
      redirect_to root_path
    end
  end

  def find_categories
    @categories = Category.order(position: :asc)
  end

  def backend?
    controller_path.split('/').first == 'admin'
  end

  def current_cart
    @session_cart ||= Cart.from_hash(session[:session_cart])
  end
end
