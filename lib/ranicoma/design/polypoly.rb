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

      def poly(center, r)
        psize = rng.rand(6..12)
        delta = Math::PI*2/psize/3
        dirs = Array.new(psize){ |ix| Math::PI*2*ix / psize + rng.rand(delta) }
        points = dirs.map{ |e|
          [Math.cos(e)*r+center[0], Math.sin(e)*r+center[1]]
        }
        element( "polygon", points:points_str(points), **fill(:red) )
      end
      def create
        [
          poly([0.5,0.5], 0.5-LINE)
        ]
      end
    end
  end
end

