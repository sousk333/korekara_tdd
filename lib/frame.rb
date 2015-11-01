class Frame
  SPARE_POWER = 1
  MAX_PINS = 10

  def initialize
    @pitches = []
    @strike = @spare = 0
    @bonus = 0
  end

  def add(pins)
    @pitches << pins
    @spare = SPARE_POWER if score == MAX_PINS
  end

  def add_bonus(pins)
    return if @spare <= 0
    @bonus = pins
    @spare -= 1
  end

  def score
    (@pitches.count == 0 ? 0 : @pitches.inject(&:+)) + @bonus
  end
end
