#
#--
# Ronin ASM - A Ruby library that provides dynamic Assembly source code
# generation.
#
# Copyright (c) 2007-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/platform'

module Ronin
  module Asm
    class PlatformTarget

      # Architecture target
      attr_reader :archtarget

      # Platform target
      attr_reader :platform

      # Platform syscall numbers
      attr_reader :syscalls

      def initialize(archtarget,platform)
        @archtarget = archtarget
        @platform = platform
        @syscalls = {}
      end

      def has_syscall?(sym)
        return false unless @syscalls.has_key?(@platform.arch.name)
        return @syscalls[@platform.arch.name].has_key?(sym)
      end

      def syscall(sym)
        @syscalls[@platform.arch.name][sym]
      end

      def to_s
        @platform.to_s
      end

      protected

      def method_missing(sym,*args)
        @archtarget.send(sym,*args)
      end

    end
  end
end
