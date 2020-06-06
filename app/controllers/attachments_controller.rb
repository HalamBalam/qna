class AttachmentsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_file, only: [:destroy]

  def destroy
    authorize! :destroy, @file

    @file.purge
    @resource.reload

    @answer = @resource.is_a?(Answer) ? @resource : nil
    @question = @resource.is_a?(Answer) ? @resource.question : @resource
    
    render "#{@file.record_type.downcase}s/update"
  end

  private

  def load_file
    @file = ActiveStorage::Attachment.find(params[:id])
    @resource = @file.record
  end

end
