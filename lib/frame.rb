class Frame
  PITCH_MAX = 2
  SPARE_POWER = 1
  STRIKE_POWER = 2
  MAX_PINS = 10

  def initialize
    @pitches = []
    @bonus_count = 0
    @bonus = 0
  end

  def add(pins)
    check_pins(pins)
    @pitches << pins
    return @bonus_count = STRIKE_POWER if strike?
    @bonus_count = SPARE_POWER if spare?
  end

  def add_bonus(pins)
    return unless need_bonus?
    @bonus += pins
    @bonus_count -= 1
  end

  def finished?
    pitch_score == Frame::MAX_PINS || @pitches.count == PITCH_MAX
  end

  def need_bonus?
    @bonus_count > 0
  end

  def pitch_score
    @pitches.count == 0 ? 0 : @pitches.inject(&:+)
  end

  def score
     pitch_score + @bonus
  end

  def spare?
    @pitches.count == PITCH_MAX && @pitches.inject(&:+) == MAX_PINS
  end

  def strike?
    @pitches.count == 1 && @pitches.first == MAX_PINS
  end

  private

  def check_pins(pins)
    unless (0..10).cover?(pins) && pitch_score + pins <= 10
      raise ArgumentError.new("bad num of pins: #{pins}")
    end
  end
end
