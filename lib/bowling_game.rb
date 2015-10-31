class BowlingGame
  def initialize
    @frame_status = Array.new(10) { [] }
    @frame_count = 0
    @this_frame = 0
    @spare_flag = false
  end

  def record_shot(pins)
    @frame_status[@frame_count] << pins
    @frame_status[@frame_count - 1] << pins if @spare_flag
    return spare if spare?

    @spare_flag = false
    return change_frame if @this_frame == 2
    @this_frame += 1
  end

  def score
    @frame_status.inject(0) do |sum, arr|
      sum + (arr.count == 0 ? 0 : arr.inject(&:+))
    end
  end

  private

  def spare?
    @this_frame > 0 && @frame_status[@frame_count].inject(&:+) == 10
  end

  def spare
    @spare_flag = true
    change_frame
  end

  def change_frame
    @this_frame = 0
    @frame_count += 1
  end
end
