class LinksController < ApplicationController

  before_action :authenticate_user!

  load_and_authorize_resource

  def destroy
    resource = @link.linkable

    @link.destroy

    @answer = resource.is_a?(Answer) ? resource : nil
    @question = resource.is_a?(Answer) ? resource.question : resource
    
    render "#{resource.class.to_s.downcase}s/update"
  end

end
