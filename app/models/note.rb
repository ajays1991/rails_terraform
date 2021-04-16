class Note < ApplicationRecord
  validates :text, presence: true

  def contains_digits?
    /\d/.match?(text)
  end
end
