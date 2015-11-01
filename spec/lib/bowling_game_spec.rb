describe BowlingGame do
  describe "#record_short" do
    before do
      @game = BowlingGame.new
    end

    subject do
      throw_count.times.each { @game.record_shot(pins) }
      @game.score
    end

    context "全ての投球がガターの場合" do
      let(:throw_count) { 20 }
      let(:pins) { 0 }
      it { expect(subject).to eq 0 }
    end

    context "全ての投球で1ピンだけ倒した" do
      let(:throw_count) { 20 }
      let(:pins) { 1 }
      it { expect(subject).to eq 20 }
    end

    context "スペアをとると次の投球のピン数を加算" do
      before do
        [3, 7, 4].each { |n| @game.record_shot(n) }
      end
      let(:throw_count) { 17 }
      let(:pins) { 0 }
      it { expect(subject).to eq 18 }
    end

    context "直前の投球と合計が10ピンでもフレーム違いはspareではない" do
      before do
        [2, 5, 5, 1].each { |n| @game.record_shot(n) }
      end
      let(:throw_count) { 16 }
      let(:pins) { 0 }
      it { expect(subject).to eq 13 }
    end

    context "ストライクをとると次の2投分のピン数を加算" do
      before do
        [10, 3, 3, 1].each { |n| @game.record_shot(n) }
      end
      let(:throw_count) { 15 }
      let(:pins) { 0 }
      it { expect(subject).to eq 23 }
    end

    context "連続ストライクすなわちダブル" do
      before do
        [10, 10, 3, 1].each { |n| @game.record_shot(n) }
      end
      let(:throw_count) { 14 }
      let(:pins) { 0 }
      it { expect(subject).to eq 41 }
    end

    context "3連続ストライクすなわちターキー" do
      before do
        [10, 10, 10, 3, 1].each { |n| @game.record_shot(n) }
      end
      let(:throw_count) { 12 }
      let(:pins) { 0 }
      it { expect(subject).to eq 71 }
    end

    context "ストライク後のスペア" do
      before do
        [10, 5, 5, 3].each { |n| @game.record_shot(n) }
      end
      let(:throw_count) { 15 }
      let(:pins) { 0 }
      it { expect(subject).to eq 36 }
    end

    context "ダブル後のスペア" do
      before do
        [10, 10, 5, 5, 3].each { |n| @game.record_shot(n) }
      end
      let(:throw_count) { 13 }
      let(:pins) { 0 }
      it { expect(subject).to eq 61 }
    end

    context "全ての投球が1ピンの場合" do
      let(:throw_count) { 20 }
      let(:pins) { 1 }

      it "全フレーム2点であること" do
        subject
        10.times.with_index(1) do |_, i|
          expect(@game.frame_score(i)).to eq 2
        end
      end
    end
  end
end
