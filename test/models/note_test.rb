require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  test "return true" do
    assert Note.new({text: "order #123"}).contains_digits?
  end

  test "return false" do
    assert_not Note.new({text: "order is blank"}).contains_digits?
  end
end