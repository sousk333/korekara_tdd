describe BowlingGame do
  describe "all_gutter_game" do
    it { expect(BowlingGame.new).to be }
  end

  describe "#record_short" do
    before do
      @game = BowlingGame.new
    end

    subject do
      20.times.each { @game.record_shot(0) }
      @game.score
    end

    it { expect(subject).to eq 0 }
  end
end
