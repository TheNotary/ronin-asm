#
# Ronin ASM - a Ruby library for Ronin that provides dynamic Assembly (ASM)
# generation of programs or shellcode.
#
# Copyright (c) 2007-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'ronin/code/asm/register'

module Ronin
  module Code
    module ASM
      class Immediate < Struct.new(:base, :offset, :scale)

        def +(offset)
          Immediate.new(self.base,self.offset + offset,self.scale)
        end

        def *(index)
          Immediate.new(self.base,self.offset,self.scale + index)
        end

        def width
          base.width if base.kind_of?(Register)
        end

        def to_ary
          [self.base, self.offset, self.scale]
        end

      end
    end
  end
end
