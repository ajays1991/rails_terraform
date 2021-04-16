class Note < ApplicationRecord
  validates :text, presence: true

  def contains_digits?
    return false
    /\d/.match?(text)
  end
end
