class NoteWorker
  include Sidekiq::Worker

  def perform(id)
    note = Note.find(id)
    note.text = note.text + " [processed]"
    note.save!
  end
end