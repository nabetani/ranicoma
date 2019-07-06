# frozen_string_literal: true

require 'rexml/document'

require "ranicoma/design/base"
require "ranicoma/rect"

module Ranicoma
  module Design
    class PolyPoly < Base
      LINE = 1.0/30

      def points_str(pts)
        pts.map{ |e| e.join(",") }.join(" ")
      end

      def colors(n)
        f = lambda{ |t0|
          v = lambda{ |t|
            case t
            when 0..1 then t
            when 1..2 then 2-t
            else 0
            end
          }[t0 % 3]
          (v**0.5*255).round
        }
        Array.new(n){ |i|
          t = i*3.0/n+2
          [f[t],f[t+1],f[t+2]]
        }
      end

      def poly(center, r)
        psize = rng.rand(6..12)
        delta = Math::PI*2/psize/3
        dirs = Array.new(psize){ |ix| Math::PI*2*ix / psize + rng.rand(delta) }
        outer = dirs.map{ |e|
          [Math.cos(e)*r+center[0], Math.sin(e)*r+center[1]]
        }
        edelta = rng.rand(-0.2..0.2) * Math::PI*2
        ri = r * rng.rand(0.2..0.5)
        inner = dirs.map{ |e|
          t = e + edelta
          [Math.cos(t)*ri+center[0], Math.sin(t)*ri+center[1]]
        }
        use = Array.new(inner.size){ rng.rand<0.8 }
        cols = rand_rotate(colors(use.count(true)))
        colbase = rng.rand(inner.size)
        center_poly = element( "polygon",
          points:points_str(inner),
          **fill(%i(black white).sample( random:rng)),
          **stroke(:black, LINE),
          "stroke-linejoin": :round )
    Array.new( outer.size ){ |ix|
          if ! use[ix]
            []
          else
            pts = [
              outer[ix % psize],
              outer[(ix+1) % psize],
              inner[(ix+1) % psize],
              inner[ix % psize]
            ]
            element( "polygon",
              points:points_str(pts),
              **fill(cols.pop),
              **stroke(:black, LINE),
              "stroke-linejoin": :round )
          end
        } + [center_poly]
      end
      def create
        [
          poly([0.5,0.5], 0.5-LINE)
        ].flatten
      end
    end
  end
end

