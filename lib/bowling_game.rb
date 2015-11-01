require_relative "frame.rb"

class BowlingGame
  FRAME_MAX = 10

  def initialize
    @frame_status = Array.new(FRAME_MAX) { Frame.new }
    @frame_count = 0
  end

  def record_shot(pins)
    @frame_status[@frame_count].add(pins)
    add_bonus(pins)
    return change_frame if @frame_status[@frame_count].finished?
  end

  def score
    @frame_status.inject(0) do |sum, frame|
      sum + frame.score
    end
  end

  def frame_score(frame_no)
    @frame_status[frame_no - 1].score
  end

  private

  def add_bonus(pins)
    2.times.with_index(1).each do |_, i|
      next if @frame_status[@frame_count - i].nil?
      @frame_status[@frame_count - i].add_bonus(pins)
    end
  end

  def change_frame
    @frame_count += 1
  end
end
