class BowlingGame
  attr_reader :score

  def initialize
    @score = 0
  end

  def record_shot(pins)
    @score += pins
  end
end
