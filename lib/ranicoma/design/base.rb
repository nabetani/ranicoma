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

      def rainbow(t,mx=->(v){v})
        f = lambda{ |t0|
          v = lambda{ |t|
            case t
            when 0..1 then t
            when 1..2 then 2-t
            else 0
            end
          }[t0 % 3]
          (mx[v]*255).round
        }
        [f[t],f[t+1],f[t+2]]
      end

      def Base.subclasses
        @subclasses
      end

      def initialize(rng)
        @rng=rng
      end

      def points_str(pts)
        pts.map{ |e| e.join(",") }.join(" ")
      end

      def rect_element(rc, col)
        element("rect", **rectpos(rc), **fill(col))
      end

      attr_reader(:rng)

      def rectpos(rc)
        { x:rc.x, y:rc.y, width:rc.w, height:rc.h }
      end

      def rand_rotate(ary)
        ix=rng.rand(ary.size)
        ary[ix,ary.size-ix] + ary[0,ix]
      end

      def fill(col)
        case col
        when Array
          { style:"fill:rgb(#{col.join(",")})" }
        when /^\d+\,\d+\,\d+$/
          { style:"fill:rgb(#{col})" }
        else
          { style:"fill:#{col}" }
        end
      end

      def stroke(col, w)
        c=case col
        when Array
          "rgb(#{col.join(",")})"
        when /^\d+\,\d+\,\d+$/
          "rgb(#{col})"
        else
          col
        end
        { stroke:c, "stroke-width":w }
      end

      def Base.inherited(subclass)
        Base.add_subclass(subclass)
      end
    end
  end
end
