describe Frame do
  before do
    @frame = Frame.new
  end

  describe "#score" do
    subject { @frame.score }

    context "投球が一回もない場合" do
      it { expect(subject).to eq 0 }
    end

    context "投球が二回あった場合" do
      before do
        @frame.instance_variable_set("@pitches", [2, 3])
      end

      it "投球の合計が返ること" do
        expect(subject).to eq 5
      end
    end

    context "ボーナスポイントがある場合" do
      before do
        @frame.instance_variable_set("@pitches", [3, 4])
        @frame.instance_variable_set("@bonus", 9)
      end

      it "投球の合計 + ボーナスポイントが返ること" do
        expect(subject).to eq 16
      end
    end
  end


  describe "#add" do
    context "一投分を追加した場合" do
      it "一投分が保存されていること" do
        pins = 6
        @frame.add(pins)
        expect(@frame.instance_variable_get("@pitches")).to match_array([pins])
      end
    end

    context "二投分を追加した場合" do
      it "二投分が保存されていること" do
        pins_arr = [7, 2]
        pins_arr.each { |pins| @frame.add(pins) }
        expect(
          @frame.instance_variable_get("@pitches")
        ).to match_array(pins_arr)
      end
    end

    context "10ピン倒した状態になった場合" do
      it "スペアポイントが設定されていること" do
        pins_arr = [4, 6]
        pins_arr.each { |pins| @frame.add(pins) }
        expect(
          @frame.instance_variable_get("@spare")
        ).to eq Frame::SPARE_POWER
      end
    end
  end

  describe "#add_bonus" do
    subject { @frame.add_bonus(pins) }
    let(:pins) { 7 }

    context "スペアポイントがない場合" do
      it "ボーナスポイントは 0 のままであること" do
        subject
        expect(@frame.instance_variable_get("@bonus")).to eq 0
      end
    end

    context "スペアポイントがある場合" do
      before do
        @frame.instance_variable_set("@spare", 1)
      end

      it "ボーナスポイントがつくこと" do
        subject
        expect(@frame.instance_variable_get("@bonus")).to eq pins
      end

      it "スペアポイントが減ること" do
        subject
        expect(@frame.instance_variable_get("@spare")).to eq 0
      end
    end
  end
end
