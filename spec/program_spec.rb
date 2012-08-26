require 'spec_helper'
require 'ronin/asm/program'

describe ASM::Program do
  describe "#arch" do
    it "should default to :x86" do
      subject.arch.should == :x86
    end
  end

  context "when :arch => :x86" do
    subject { described_class.new(:arch => :x86) }

    its(:word_size) { should == 4 }

    describe "#syscall" do
      before { subject.syscall }

      it "should add an 'int 0x80' instruction" do
        subject.instructions[-1].name.should == :int
        subject.instructions[-1].operands[0].value.should == 0x80
      end
    end
  end

  context "when :arch => :amd64" do
    subject { described_class.new(:arch => :amd64) }

    its(:word_size) { should == 8 }

    describe "#syscall" do
      before { subject.syscall }

      it "should add a 'syscall' instruction" do
        subject.instructions[-1].name.should == :syscall
      end
    end
  end

  describe "#register" do
    it "should return a Register" do
      subject.register(:eax).should be_kind_of(ASM::Register)
    end

    it "should allocate the register" do
      subject.register(:ebx)

      subject.allocated_registers.should include(:ebx)
    end

    context "when given an unknown register name" do
      it "should raise an ArgumentError" do
        lambda {
          subject.register(:foo)
        }.should raise_error(ArgumentError)
      end
    end
  end

  describe "#instruction" do
    it "should return an Instruction" do
      subject.instruction(:hlt).should be_kind_of(ASM::Instruction)
    end

    it "should append the new Instruction" do
      subject.instruction(:push, 1)

      subject.instructions.last.name.should == :push
    end
  end

  describe "#byte" do
    it "should return a ImmedateOperand" do
      subject.byte(1).should be_kind_of(ImmediateOperand)
    end

    it "should have width of 1" do
      subject.byte(1).width.should == 1
    end
  end

  describe "#word" do
    it "should return a ImmediateOperand" do
      subject.word(1).should be_kind_of(ImmediateOperand)
    end

    it "should have width of 2" do
      subject.word(1).width.should == 2
    end
  end

  describe "#dword" do
    it "should return a ImmediateOperand" do
      subject.dword(1).should be_kind_of(ImmediateOperand)
    end

    it "should have width of 4" do
      subject.dword(1).width.should == 4
    end
  end

  describe "#qword" do
    it "should return a ImmediateOperand" do
      subject.qword(1).should be_kind_of(ImmediateOperand)
    end

    it "should have width of 8" do
      subject.qword(1).width.should == 8
    end
  end

  describe "#label" do
    let(:name) { :_start }

    it "should return the label name" do
      label = subject.label(name) { }
      
      label.should == name
    end

    it "should add the label to the instructions" do
      subject.label(name) { }

      subject.instructions.last.should == name
    end

    it "should accept a block" do
      subject.label(name) { push 2 }

      subject.instructions[-1].name.should == :push
      subject.instructions[-2].should == name
    end
  end

  describe "#method_missing" do
    context "when called without a block" do
      it "should add a new instruction" do
        subject.pop

        subject.instructions[-1].name.should == :pop
      end
    end

    context "when called with one argument and a block" do
      it "should add a new label" do
        subject._loop { mov eax, ebx }

        subject.instructions[-2].should      == :_loop
        subject.instructions[-1].name.should == :mov
      end
    end
  end

  describe "#to_asm" do
    subject do
      described_class.new do
        push eax
        push ebx
        push ecx

        mov eax, ebx
        mov eax+0, ebx
        mov eax+4, ebx
        mov eax+esi, ebx
        mov eax+(esi*4), ebx
        mov eax+(esi*4)+10, ebx
      end
    end

    it "should convert the program to ATT syntax" do
      subject.to_asm.should == [
        "_start:",
        "\tpushl\t%eax",
        "\tpushl\t%ebx",
        "\tpushl\t%ecx",
        "\tmovl\t%eax,\t%ebx",
        "\tmovl\t(%eax),\t%ebx",
        "\tmovl\t0x4(%eax),\t%ebx",
        "\tmovl\t(%eax,%esi),\t%ebx",
        "\tmovl\t(%eax,%esi,4),\t%ebx",
        "\tmovl\t0xa(%eax,%esi,4),\t%ebx",
        ""
      ].join($/)
    end

    context "when given :intel" do
      it "should convert the program to Intel syntax" do
        subject.to_asm(:intel).should == [
          "_start:",
          "\tpush\teax",
          "\tpush\tebx",
          "\tpush\tecx",
          "\tmov\tebx,\teax",
          "\tmov\tebx,\t[eax]",
          "\tmov\tebx,\t[eax+0x4]",
          "\tmov\tebx,\t[eax+esi]",
          "\tmov\tebx,\t[eax+esi*0x4]",
          "\tmov\tebx,\t[eax+esi*0x4+0xa]",
          ""
        ].join($/)
      end
    end
  end

  describe "#assemble" do
  end
end
