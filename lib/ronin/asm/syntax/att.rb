#
# Ronin ASM - A Ruby DSL for crafting Assembly programs and Shellcode.
#
# Copyright (c) 2007-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin ASM.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>
#

require 'ronin/asm/syntax/common'

module Ronin
  module ASM
    module Syntax
      #
      # Handles emitting Assembly source code in ATT syntax.
      #
      class ATT < Common

        # Data sizes and their instruction mnemonics
        WIDTHS = {
          8 => 'q',
          4 => 'l',
          2 => 'w',
          1 => 'b',
          nil => ''
        }

        #
        # Emits a register.
        #
        # @param [Register] reg
        #   The register.
        #
        # @return [String]
        #   The register name.
        #
        def self.emit_register(reg)
          "%#{reg.name}"
        end

        #
        # Emits an immediate operand.
        #
        # @param [ImmediateOperand] op
        #   The operand.
        #
        # @return [String]
        #   The formatted immediate operand.
        #
        def self.emit_immediate_operand(op)
          "$#{emit_integer(op.value)}"
        end

        #
        # Emits a memory operand.
        #
        # @param [MemoryOperand] op
        #   The operand.
        #
        # @return [String]
        #   The formatted memory operand.
        #
        def self.emit_memory_operand(op)
          asm = emit_register(op.base)

          if op.index
            asm << ',' << emit_register(op.index)
            asm << ',' << op.scale.to_s if op.scale > 1
          end

          asm = "(#{asm})"
          asm = emit_integer(op.offset) + asm if op.offset != 0

          return asm
        end

        #
        # Emits an instruction.
        #
        # @param [Instruction] ins
        #   The instruction.
        #
        # @return [String]
        #   The formatted instruction.
        #
        def self.emit_instruction(ins)
          line = emit_keyword(ins.name)

          unless ins.operands.empty?
            unless (ins.operands.length == 1 && ins.width == 1)
              line << WIDTHS[ins.width]
            end

            line << "\t" << emit_operands(ins.operands)
          end

          return line
        end

        #
        # Emits a program.
        #
        # @param [Program] program
        #   The program.
        #
        # @return [String]
        #   The formatted program.
        #
        def self.emit_program(program)
          asm = super(program)

          # prepend the `.code64` directive for YASM
          if program.arch == :amd64
            asm = [".code64", '', asm].join($/)
          end

          return asm
        end

      end
    end
  end
end
