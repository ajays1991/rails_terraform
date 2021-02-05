class NotesController < ApplicationController
	def index
    @notes = Note.order("created_at desc")
  end

  def create
    note = Note.create(text: params[:note][:text])
    NoteWorker.perform_async(note.id)
    redirect_to notes_path
  end
end