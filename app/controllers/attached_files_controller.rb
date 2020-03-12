class AttachedFilesController < ApplicationController

  before_action :authenticate_user!

  def delete_file
    file = ActiveStorage::Attachment.find(params[:id])

    resource = eval(file.record_type).find(file.record_id)

    if current_user&.author?(resource)
      file.purge
      resource.reload
    end

    if resource.is_a?(Answer)
      @answer = resource
      @question = @answer.question
    else
      @question = resource
    end
    
    render "#{file.record_type.downcase}s/update"
  end

end
