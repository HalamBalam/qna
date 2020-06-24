class Api::V1::ProfilesController < Api::V1::BaseController
  before_action :profiles_authorize

  def me
    render json: current_resource_owner
  end

  def index
    @users = User.where('id != ?', current_resource_owner.id)
    render json: @users
  end

  private

  def profiles_authorize
    authorize! :read, User
  end
end
