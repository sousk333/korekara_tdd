require_relative "frame.rb"

class BowlingGame
  def initialize
    @frame_status = [ Frame.new ]
  end

  def frame_score(frame_no)
    @frame_status[frame_no - 1].score
  end

  def record_shot(pins)
    @frame_status.last.add(pins)
    add_bonus(pins)
    return change_frame if @frame_status.last.finished?
  end

  def score
    @frame_status.inject(0) { |sum, frame| sum += frame.score }
  end

  private

  def add_bonus(pins)
    @frame_status[0..-2].select(&:need_bonus?).each do |frame|
      frame.add_bonus(pins)
    end
  end

  def change_frame
    @frame_status << Frame.new
  end
end
