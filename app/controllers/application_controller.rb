class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    if request_format == :html
      redirect_to root_url, alert: exception.message
    else
      respond_to do |format|
        format.json { render json: ["You don't have permission to access on this server"], status: :forbidden }
        format.js { render json: ["You don't have permission to access on this server"], status: :forbidden }
      end
    end
  end

  check_authorization unless: :devise_controller?
end
