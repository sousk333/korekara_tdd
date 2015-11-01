require_relative "frame.rb"

class BowlingGame
  def initialize
    @frame_status = Array.new(10) { Frame.new }
    @frame_count = 0
    @this_frame = 0
  end

  def record_shot(pins)
    @frame_status[@frame_count].add(pins)
    add_bonus(pins)
    return change_frame if chage_frame?
    @this_frame += 1
  end

  def score
    @frame_status.inject(0) do |sum, frame|
      sum + frame.score
    end
  end

  private

  def add_bonus(pins)
    return if @frame_status[@frame_count - 1].nil?
    @frame_status[@frame_count - 1].add_bonus(pins)
  end

  def chage_frame?
    @frame_status[@frame_count].score == Frame::MAX_PINS || @this_frame == 1
  end

  def change_frame
    @this_frame = 0
    @frame_count += 1
  end
end
