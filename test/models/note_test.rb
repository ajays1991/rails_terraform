require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  test "return true" do
    assert Note.new({text: "order #123"}).contains_digits?
  end

  test "return false" do
    assert_not Note.new({text: "order is blank"}).contains_digits?
  end

  test "returns notes count" do
    2.times { |i| Note.create(text: "note #{i}") }
    assert_equal Note.count, 2
  end
end