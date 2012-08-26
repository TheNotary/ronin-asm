require 'spec_helper'

require 'ronin/asm/archs/x86'
require 'ronin/asm/program'

describe Archs::X86 do
  let(:program) { Program.new(:arch => :x86) }

  subject { program }

  describe "#syscall" do
    before { subject.syscall }

    it "should add an 'int 0x80' instruction" do
      subject.instructions[-1].name.should == :int
      subject.instructions[-1].operands[0].value.should == 0x80
    end
  end
end
