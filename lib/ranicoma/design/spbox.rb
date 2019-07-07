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
      COLMAKERS=[]

      def create_cols
        send COLMAKERS.sample(random:rng)
      end

      COLMAKERS<<
      def rainbow_cols
        colcount = rng.rand(3..7)
        base = rng.rand(100.0)
        cols = Array.new(colcount){ |ix| rainbow( ix*3.0/colcount+base+rng.rand(3.0/colcount) ) }
        cols.flat_map{ |e|
          [e] + [:white]*rng.rand(2)
        }
      end

      COLMAKERS<<
      def pale_cols
        colcount = rng.rand(3..7)
        base = rng.rand(100.0)
        f = ->(x){ x/2+0.5 }
        ( Array.new(colcount){ |ix| 
          rainbow( ix*3.0/colcount+base+rng.rand(3.0/colcount), f ) 
        } + [[40]*3, :white] ).shuffle( random:rng )
      end

      COLMAKERS<<
      def basic_cols
        colcount = rng.rand(3..7)
        cols=%i(red green blue yellow cyan magenta green).shuffle( random:rng ).take(colcount)
        cols.flat_map{ |e|
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

      def fill?(depth)
        prob = [0.1, 0.4][depth] || 0.6
        rng.rand < prob
      end

      def hsubbox( rc, depth )
        ratio=rng.rand(0.3..0.7)
        rest = (rc.w - LINE)
        return rect_element(rc, randcol) if rest<MINSIZE
        left = rest*ratio
        right = rest-left
        rc_l = Rect.new( rc.x, rc.y, left, rc.h )
        rc_r = Rect.new( rc.right-right, rc.y, right, rc.h )
        [
          ( fill?(depth) ? rect_element(rc_l, randcol) : vsubbox(rc_l, depth+1) ),
          ( fill?(depth) ? rect_element(rc_r, randcol) : vsubbox(rc_r, depth+1) )
        ]
      end

      def vsubbox( rc, depth )
        ratio=rng.rand(0.3..0.7)
        rest = (rc.h - LINE)
        return rect_element(rc, randcol) if rest<MINSIZE
        top = rest*ratio
        bottom = rest-top
        rc_t = Rect.new( rc.x, rc.y, rc.w, top )
        rc_b = Rect.new( rc.x, rc.bottom-bottom, rc.w, bottom)
        [
          ( fill?(depth) ? rect_element(rc_t, randcol) : hsubbox(rc_t, depth+1 ) ),
          ( fill?(depth) ? rect_element(rc_b, randcol) : hsubbox(rc_b, depth+1 ) )
        ]
      end

      def create
        total = Rect.new( LINE, LINE, 1-LINE*2, 1-LINE*2 )
        dir=%i(h v).sample( random:rng )
        [
          element("rect", height:1, width:1, **fill(:black)),
          case dir
          when :h
            hsubbox(total, 0)
          when :v
            vsubbox(total, 0)
          end
        ].flatten
      end
    end
  end
end

