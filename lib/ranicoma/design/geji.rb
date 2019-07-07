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
        @center_rc = Rect.new( projsize, projsize, 1-projsize*2, 1-projsize*2 )
      end

      def proj_attr
        fill(rainbow(rand(3.0))).merge(stroke(:black, line_width))
      end

      attr_reader(:line_width)
      attr_reader(:projsize)
      attr_reader(:center_rc)

      def eqcolors(n)
        base=rand(3.0)
        Array.new(n){ |ix|
          rainbow(base+3.0*ix/n)
        }
      end
      def center_rect
        gx = center_rc.w * rand(0.05..0.3)
        gy = center_rc.h * rand(0.05..0.3)
        w0 = (center_rc.w-gx*2)*rand(0.6..0.9)
        h0 = (center_rc.h-gy*2)*rand(0.6..0.9)
        w1 = (center_rc.w-gx*2)*rand(0.6..0.9)
        h1 = (center_rc.h-gy*2)*rand(0.6..0.9)
        subrects = if rand(2)==0
          [
            Rect.new( center_rc.x+gx, center_rc.y+gy, w0, h0 ),
            Rect.new( center_rc.right-gx-w1, center_rc.bottom-gy-h1, w1, h1 ),
          ]
        else
          [
            Rect.new( center_rc.right-gx-w0, center_rc.y+gy, w0, h0 ),
            Rect.new( center_rc.x+gx, center_rc.bottom-gy-h1, w1, h1 ),
          ]
        end.shuffle( random:rng )
        if rand(2)==0
          h = [h0, h1].min * rand(0.3..1.1)
          w = [w0, w1].min * rand(0.3..1.1)
          subrects.push( Rect.new( center_rc.cx-w/2, center_rc.cy-h/2, w, h ) )
        end
        cols = eqcolors(subrects.size+1)
        makeattr=->(){
          {
            rx:line_width*3,
            **fill(cols.pop),
            **stroke(:black, line_width)
          }
        }
        ([ center_rc  ]+subrects).map{ |rc|
          element( "rect", **rectpos(rc), **makeattr[] )
        }
      end

      def shorten_rc(rc)
        d = rand(rc.h/2)
        Rect.new( rc.x, rc.y+d, rc.w, rc.h-d )
      end

      def bezier(rc, corners)
        q = corners.each_cons(2).map{ |(x0,y0),(x1,y1)|
          mx = (x0+x1)/2.0
          my = (y0+y1)/2.0
          "Q #{x0} #{y0} #{mx} #{my} "
        }
        path = <<~PATH
          M #{rc.x} #{rc.bottom}
          #{q.join}
          L #{corners.last.join(" ")}
          L #{rc.x} #{rc.bottom}
        PATH
        element( "path", d:path, **proj_attr )
      end

      PROJ_METHODS<<
      def bezier0(rc0)
        rc = shorten_rc(rc0)
        y0 = rc.y + rc.h*(2.0/3)
        y1 = rc.y + rc.h*(1.0/3)
        corners = [
          [ rc.x, rc.bottom ],
          [ rc.x, y0 ],
          [ rc.cx, y0 ],
          [ rc.cx, y1 ],
          [ rc.x, y1 ],
          [ rc.x, rc.y ],
          [ rc.right, rc.y ],
          [ rc.right, rc.bottom ],
        ]
        if rand(2)==0
          bezier(rc, corners.map{ |x,y| [rc.cx*2-x, y] } )
        else
          bezier(rc, corners)
        end
      end

      PROJ_METHODS<<
      def bezier1(rc0)
        rc = shorten_rc(rc0)
        y0 = rc.y + rc.h*(2.0/3)
        y1 = rc.y + rc.h*(1.0/3)
        corners = [
          [ rc.x, rc.bottom ],
          [ rc.x, y0 ],
          [ rc.cx, y0 ],
          [ rc.x, y0 ],
          [ rc.x, y1 ],
          [ rc.cx, y1 ],
          [ rc.x, y1 ],
          [ rc.x, rc.y ],
          [ rc.right, rc.y ],
          [ rc.right, rc.bottom ],
        ]
        if rand(2)==0
          bezier(rc, corners.map{ |x,y| [rc.cx*2-x, y] } )
        else
          bezier(rc, corners)
        end
      end

      PROJ_METHODS<<
      def bezier2(rc0)
        rc = shorten_rc(rc0)
        y0 = rc.y + rc.h*(2.0/3)
        y1 = rc.y + rc.h*(1.0/3)
        corners = [
          [ rc.x, rc.bottom ],
          [ rc.x, y0 ],
          [ rc.cx, y0 ],
          [ rc.x, y0 ],
          [ rc.x, y1 ],
          [ rc.cx, y1 ],
          [ rc.x, y1 ],
          [ rc.x, rc.y ],
          [ rc.right, rc.y ],
          [ rc.right, y1 ],
          [ rc.cx, y1 ],
          [ rc.right, y1 ],
          [ rc.right, y0 ],
          [ rc.cx, y0 ],
          [ rc.right, y0 ],
          [ rc.right, rc.bottom ],
        ]
        bezier(rc, corners)
      end

      PROJ_METHODS<<
      def bezier3(rc0)
        rc = shorten_rc(rc0)
        y0 = rc.y + rc.h*0.9
        y1 = rc.y + rc.h*(1.0/3)
        x0 = rc.x + rc.w*0.4
        x1 = rc.x + rc.w*0.6
        corners = [
          [ rc.x, rc.bottom ],
          [ rc.x, y0 ],
          [ x0, y0 ],
          [ x0, y1 ],
          [ rc.x, y1 ],
          [ rc.x, rc.y ],
          [ rc.right, rc.y ],
          [ rc.right, y1 ],
          [ x1, y1 ],
          [ x1, y0 ],
          [ rc.right, y0 ],
          [ rc.right, rc.bottom ],
        ]
        bezier(rc, corners)
      end

      PROJ_METHODS<<
      def box_proj(rc0)
        rc = shorten_rc(rc0)
        element( "rect",
          **rectpos(rc),
          **proj_attr )
      end

      PROJ_METHODS<<
      def roundbox_proj(rc0)
        d = rand(rc0.h/2)
        rx = [rc0.w, rc0.h].min/3
        rc = Rect.new( rc0.x, rc0.y+d, rc0.w, rc0.h+rx-d )
        element( "rect",
          **rectpos(rc),
          rx:rx,
          **proj_attr )
      end

      PROJ_METHODS<<
      def triangle_proj(rc0)
        rc = shorten_rc(rc0)
        points = [ [rc.cx,rc.y], [rc.x, rc.bottom], [rc.right, rc.bottom] ]
        element("polygon",
          points:points_str(points),
          **proj_attr,
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
        pattern = rand(1..2**count-1) | rand(1..2**count-1)
        element("g", transform:rot ){
          Array.new(count){ |ix|
            if pattern[ix]==0
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
            projects(pos)
          },
          center_rect
        ].flatten
      end
    end
  end
end

