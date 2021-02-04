class Note < ApplicationRecord
  validates :text, presence: true
end
