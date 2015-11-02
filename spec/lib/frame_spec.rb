describe Frame do
  before do
    @frame = Frame.new
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
          @frame.instance_variable_get("@bonus_count")
        ).to eq Frame::SPARE_POWER
      end
    end


    shared_examples "Raise ArgumentError" do
      it "ArgumentError 例外が発生すること" do
        expect { @frame.add(pins) }.to raise_error(ArgumentError)
      end
    end

    context "ピン数が0未満の場合" do
      let(:pins) { -1 }
      include_examples "Raise ArgumentError"
    end

    context "ピン数が11以上の場合" do
      let(:pins) { 11 }
      include_examples "Raise ArgumentError"
    end

    context "フレームの合計ピン数が11以上の場合" do
      before do
        @frame.add(5)
      end
      let(:pins) { 6 }
      include_examples "Raise ArgumentError"
    end
  end

  describe "#add_bonus" do
    subject { @frame.add_bonus(pins) }
    let(:pins) { 7 }

    context "ボーナスカウントがない場合" do
      it "ボーナスポイントは 0 のままであること" do
        subject
        expect(@frame.instance_variable_get("@bonus")).to eq 0
      end
    end

    context "スペア分のカウントがある場合" do
      before do
        @frame.instance_variable_set("@bonus_count", Frame::SPARE_POWER)
      end

      it "ボーナスポイントがつくこと" do
        subject
        expect(@frame.instance_variable_get("@bonus")).to eq pins
      end

      it "ボーナスカウントが減ること" do
        subject
        expect(@frame.instance_variable_get("@bonus_count")).to eq 0
      end
    end
  end

  describe "#finished?" do
    subject { @frame.finished? }

    context "一投終えた場合" do
      before do
        @frame.instance_variable_set("@pitches", [2])
      end

      it { expect(subject).to be_falsey }
    end

    context "二投終えた場合" do
      before do
        @frame.instance_variable_set("@pitches", [1, 2])
      end

      it { expect(subject).to be_truthy }
    end

    context "一投で10ピン倒した場合" do
      before do
        @frame.instance_variable_set("@pitches", [10])
      end

      it { expect(subject).to be_truthy }
    end
  end

  describe "#need_bonus?" do
    subject { @frame.need_bonus? }

    context "オープンフレームの場合" do
      before do
        [5, 3].each { |pins| @frame.add(pins) }
      end

      it "ボーナスは不要" do
        expect(subject).to be_falsey
      end
    end

    context "スペアのボーナスは1投分で完了" do
      before do
        [5, 5].each { |pins| @frame.add(pins) }
      end

      it "ボーナス付与前はボーナスが必要" do
        expect(subject).to be_truthy
      end
    end
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

  describe "#spare?" do
    subject { @frame.spare? }

    context "投球してない場合" do
      it { expect(subject).to be_falsey }
    end

    context "一投の場合" do
      before do
        @frame.instance_variable_set("@pitches", [5])
      end

      it { expect(subject).to be_falsey }
    end

    context "一投ので10ピン倒した場合" do
      before do
        @frame.instance_variable_set("@pitches", [10])
      end

      it { expect(subject).to be_falsey }
    end

    context "二投の場合" do
      before do
        @frame.instance_variable_set("@pitches", [7, 2])
      end

      it { expect(subject).to be_falsey }
    end

    context "二投で10ピン倒した場合" do
      before do
        @frame.instance_variable_set("@pitches", [7, 3])
      end

      it { expect(subject).to be_truthy }
    end
  end

  describe "#strike?" do
    subject { @frame.strike? }

    context "投球してない場合" do
      it { expect(subject).to be_falsey }
    end

    context "一投の場合" do
      before do
        @frame.instance_variable_set("@pitches", [5])
      end

      it { expect(subject).to be_falsey }
    end

    context "一投ので10ピン倒した場合" do
      before do
        @frame.instance_variable_set("@pitches", [10])
      end

      it { expect(subject).to be_truthy }
    end

    context "二投の場合" do
      before do
        @frame.instance_variable_set("@pitches", [7, 2])
      end

      it { expect(subject).to be_falsey }
    end

    context "二投で10ピン倒した場合" do
      before do
        @frame.instance_variable_set("@pitches", [7, 3])
      end

      it { expect(subject).to be_falsey }
    end
  end
end
