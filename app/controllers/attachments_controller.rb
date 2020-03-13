class AttachmentsController < ApplicationController

  before_action :authenticate_user!

  def destroy
    file = ActiveStorage::Attachment.find(params[:id])

    resource = file.record

    if current_user&.author?(resource)
      file.purge
      resource.reload
    end

    @answer = resource.is_a?(Answer) ? resource : nil
    @question = resource.is_a?(Answer) ? resource.question : resource
    
    render "#{file.record_type.downcase}s/update"
  end

end
