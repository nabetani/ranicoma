# frozen_string_literal: true

require "ranicoma/util"
require "ranicoma/rect"

module Ranicoma
  module Design
    class Base
      include Util
      def self.add_subclass(cls)
        @subclasses ||= []
        @subclasses.push(cls)
      end

      def Base.subclasses
        @subclasses
      end

      def initialize(rng)
        @rng=rng
      end

      def rect_element(rc, col)
        element("rect", **rectpos(rc), **fill(col))
      end

      attr_reader(:rng)

      def rectpos(rc)
        { x:rc.x, y:rc.y, width:rc.w, height:rc.h }
      end

      def fill(col)
        case col
        when /^\d+\,\d+\,\d+$/
          { style:"fill:rgb(#{col})" }
        else
          { style:"fill:#{col}" }
        end
      end

      def Base.inherited(subclass)
        Base.add_subclass(subclass)
      end
    end
  end
end
