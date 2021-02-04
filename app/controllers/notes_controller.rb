class NotesController < ApplicationController
	def index
    @notes = Note.order("created_at desc")
  end

  def create
    Note.create(text: params[:note][:text])
    redirect_to notes_path
  end
end