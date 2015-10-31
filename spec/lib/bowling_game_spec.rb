describe BowlingGame do
  describe "#record_short" do
    before do
      @game = BowlingGame.new
    end

    subject do
      20.times.each { @game.record_shot(pins) }
      @game.score
    end

    context "全ての投球がガターの場合" do
      let(:pins) { 0 }
      it { expect(subject).to eq 0 }
    end

    context "全ての投球で1ピンだけ倒した" do
      let(:pins) { 1 }
      it { expect(subject).to eq 20 }
    end
  end
end
