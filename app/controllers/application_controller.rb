class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?

  def angular
    render 'layouts/application'
  end

  def active_icon status
    if status == "active"
      icon = "thumb_up"
    else
      icon = "thumb_down"
    end
    "<i class='material-icons'>#{icon}</i>"
  end

  def snmp_walk creds, table_columns, &block
    SNMP::Manager.open(
      host: creds[:host],
      community: creds[:community]
    ) do |manager|
      manager.walk(table_columns) do |row|
        yield row
      end
    end
  end

  helper_method :current_user, :active_icon,:snmp_walk

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :full_name
  end
end
