require 'spec_helper'

require 'ronin/asm/immediate_operand'

describe ImmediateOperand do
  let(:value) { 0xff }

  describe "#initialize" do
    context "with a width" do
      let(:width) { 2 }

      subject { described_class.new(value,width) }

      it "should set the width" do
        subject.width.should == width
      end
    end

    describe "default width for" do
      context "0x100000000 .. 0xffffffffffffffff" do
        subject { described_class.new(0xffffffffffffffff).width }

        it { should == 8 }
      end

      context "-0x800000000 .. -0x7fffffffffffffff" do
        subject { described_class.new(-0x7fffffffffffffff).width }

        it { should == 8 }
      end

      context "0x10000 .. 0xffffffff" do
        subject { described_class.new(0xffffffff).width }

        it { should == 4 }
      end

      context "-0x80000 .. -0x7fffffff" do
        subject { described_class.new(-0x7fffffff).width }

        it { should == 4 }
      end

      context "0x100 .. 0xffff" do
        subject { described_class.new(0xffff).width }

        it { should == 2 }
      end

      context "-0x80 .. -0x7fff" do
        subject { described_class.new(-0x7fff).width }

        it { should == 2 }
      end

      context "0x0 .. 0xff" do
        subject { described_class.new(0xff).width }

        it { should == 1 }
      end

      context "0x0 .. -0x7f" do
        subject { described_class.new(-0x7f).width }

        it { should == 1 }
      end
    end
  end

  describe "#to_i" do
    subject { described_class.new(value) }

    it "should return the value" do
      subject.to_i.should == value
    end
  end
end
