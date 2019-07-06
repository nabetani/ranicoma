# frozen_string_literal: true

require 'rexml/document'

require "ranicoma/design/base"
require "ranicoma/rect"

module Ranicoma
  module Design
    class SpBox < Base
      LINE = 1.0/30
      MINSIZE = LINE*2
      COLS= %i( red blue yellow green )

      def create_cols
        (COLS*3).shuffle.take(COLS.size*2).flat_map{ |e|
          [e] + [:white]*rng.rand(2)
        }
      end

      def initialize(rng)
        super
        @cols=create_cols
        @col_ix=rng.rand(@cols.size)
      end

      def randcol
        @col_ix = (@col_ix+1) % @cols.size
        @cols[ @col_ix ]
      end

      def hsubbox( rc )
        ratio=rng.rand(0.3..0.7)
        rest = (rc.w - LINE)
        return rect_element(rc, randcol) if rest<MINSIZE
        left = rest*ratio
        right = rest-left
        rc_l = Rect.new( rc.x, rc.y, left, rc.h )
        rc_r = Rect.new( rc.right-right, rc.y, right, rc.h )
        [
          ( rng.rand<0.5 ? rect_element(rc_l, randcol) : vsubbox(rc_l) ),
          ( rng.rand<0.5 ? rect_element(rc_r, randcol) : vsubbox(rc_r) )
        ]
      end

      def vsubbox( rc )
        ratio=rng.rand(0.3..0.7)
        rest = (rc.h - LINE)
        return rect_element(rc, randcol) if rest<MINSIZE
        top = rest*ratio
        bottom = rest-top
        rc_t = Rect.new( rc.x, rc.y, rc.w, top )
        rc_b = Rect.new( rc.x, rc.bottom-bottom, rc.w, bottom)
        [
          ( rng.rand<0.5 ? rect_element(rc_t, randcol) : hsubbox(rc_t) ),
          ( rng.rand<0.5 ? rect_element(rc_b, randcol) : hsubbox(rc_b) )
        ]
      end

      def create
        total = Rect.new( LINE, LINE, 1-LINE*2, 1-LINE*2 )
        dir=%i(h v).sample( random:rng )
        [
          element("rect", height:1, width:1, **fill(:black)),
          case dir
          when :h
            hsubbox(total)
          when :v
            vsubbox(total)
          end
        ].flatten
      end
    end
  end
end

