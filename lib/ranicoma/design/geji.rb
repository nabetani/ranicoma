# frozen_string_literal: true

require 'rexml/document'

require "ranicoma/design/base"
require "ranicoma/rect"

module Ranicoma
  module Design
    class Geji < Base

      PROJ_METHODS=[]

      def initialize(rng)
        super
        @line_width = 1.0/80
        @projsize = rand(0.1..0.3)
        @projpattern = rand(1..15)
        @center_rc = Rect.new( projsize, projsize, 1-projsize*2, 1-projsize*2 )
      end

      attr_reader(:line_width)
      attr_reader(:projsize)
      attr_reader(:projpattern)
      attr_reader(:center_rc)

      def center_rect
        element( "rect",
          **rectpos(center_rc),
          rx:line_width*3,
          **fill(:gray), **stroke(:black, line_width) )
      end

      PROJ_METHODS<<
      def box_proj(rc0)
        d = rand(rc0.h/2)
        rc = Rect.new( rc0.x, rc0.y+d, rc0.w, rc0.h-d )
        element( "rect",
          **rectpos(rc),
          **fill(:gray), **stroke(:black, line_width) )
      end

      PROJ_METHODS<<
      def roundbox_proj(rc0)
        d = rand(rc0.h/2)
        rx = [rc0.w, rc0.h].min/3
        rc = Rect.new( rc0.x, rc0.y+d, rc0.w, rc0.h+rx-d )
        element( "rect",
          **rectpos(rc),
          rx:rx,
          **fill(:gray), **stroke(:black, line_width) )
      end

      PROJ_METHODS<<
      def triangle_proj(rc)
        points = [ [rc.cx,rc.y], [rc.x, rc.bottom], [rc.right, rc.bottom] ]
        element("polygon",
          points:points_str(points),
          **fill(:yellow), **stroke(:black, line_width),
          "stroke-linejoin": :round )
      end

      def projects(pos)
        count = rand(2..5)
        rot = "rotate(#{90*pos},0.5,0.5)"
        proj_rects = center_rc.hsplit(*([1]*count))
        proj_rects.each{ |e|
          e.x += e.w*0.1
          e.w *= 0.8
          e.y=line_width
          e.h = projsize
        }
        pat = rand(1..(2**count-1)) | rand(1..(2**count-1))
        element("g", transform:rot ){
          Array.new(count){ |ix|
            if pat[ix]==0
              []
            else
              send PROJ_METHODS.sample(random:rng), proj_rects[ix]
            end
          }.flatten
        }
      end

      def create
        [
          Array.new(4){ |pos|
            projpattern[pos]!=0 ? projects(pos) : []
          },
          center_rect
        ].flatten
      end
    end
  end
end

