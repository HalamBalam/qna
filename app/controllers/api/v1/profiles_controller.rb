class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User, except: [:me]

  def me
    authorize! :read_owner, current_resource_owner
    render json: current_resource_owner
  end

  def index
    @users = User.where('id != ?', current_resource_owner.id)
    render json: @users
  end
end
