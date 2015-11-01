class Frame
  PITCH_MAX = 2
  SPARE_POWER = 1
  STRIKE_POWER = 2
  MAX_PINS = 10

  def initialize
    @pitches = []
    @strike = @spare = 0
    @bonus = 0
  end

  def add(pins)
    @pitches << pins
    return @strike = STRIKE_POWER if strike?
    @spare = SPARE_POWER if spare?
  end

  def add_bonus(pins)
    return if @spare <= 0 && @strike <= 0
    @bonus += pins
    @strike -= 1
    @spare -= 1
  end

  def score
     pitch_score + @bonus
  end

  def finished?
    pitch_score == Frame::MAX_PINS || @pitches.count == PITCH_MAX
  end

  def strike?
    @pitches.count == 1 && @pitches.first == MAX_PINS
  end

  def spare?
    @pitches.count == PITCH_MAX && @pitches.inject(&:+) == MAX_PINS
  end

  def pitch_score
    @pitches.count == 0 ? 0 : @pitches.inject(&:+)
  end
end
