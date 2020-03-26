class LinksController < ApplicationController

  before_action :authenticate_user!

  def destroy
    link = Link.find(params[:id])

    resource = link.linkable

    if current_user&.author?(resource)
      link.destroy
    end

    @answer = resource.is_a?(Answer) ? resource : nil
    @question = resource.is_a?(Answer) ? resource.question : resource
    
    render "#{resource.class.to_s.downcase}s/update"
  end

end
