# frozen_string_literal: true

require 'rexml/document'

require "ranicoma/design/base"
require "ranicoma/rect"

module Ranicoma
  module Design
    class RotObj < Base
      LINE = 1.0/80
      def initialize(rng)
        super
        @ct0 = rng.rand(Math::PI*2)
        @count = rng.rand(5..10)
        @body_seed = rng.rand(2**256)
      end

      attr_reader(:count)
      attr_reader(:body_seed)

      def make_dists(body_rng, lo, hi, depth)
        return [] if depth<=0
        x = (hi-lo)*0.2
        mid = body_rng.rand(lo+x..hi-x)
        [
          body_rng.rand(lo..mid),
          make_dists(body_rng, lo, mid, depth-1),
          make_dists(body_rng, mid, hi, depth-1),
          body_rng.rand(mid..hi),
        ]
      end

      def colmove( r, c )
        delta = 80
        f = ->(x){ r.rand(x-delta..x+delta).clamp(0,255).round }
        c.map{ |e| f[e] }
      end

      def body(theta, seed)
        body_rng = Random.new(seed)
        arc=20
        r=0.48
        dt = Math::PI*2/count/2*0.9
        t0 = -Math::PI/2 - dt
        t1 = -Math::PI/2 + dt
        pts = [
          [0.5, 0.5]
        ]+Array.new(arc+1){ |ix|
          t = (t1-t0)*ix*1.0/arc + t0
          [Math.cos(t)*r+0.5, Math.sin(t)*r+0.5]
        }
        bc = rainbow( theta*3/(Math::PI*2) + @ct0 )
        dists=make_dists(body_rng, 0, 0.5, 3).flatten
        clip_id = Random.new_seed
        [
          element( "clipPath", id:clip_id ){
            element( "polygon", points:points_str(pts))
          },
          element( "g", "clip-path":"url(##{clip_id})", style:"fill:#0000" ){
            dists.map{ |dist|
              t = body_rng.rand(t0..t1)
              cx = Math.cos(t)*dist + 0.5
              cy = Math.sin(t)*dist + 0.5
              cr = body_rng.rand(0.05..0.1)
              color = colmove(body_rng,bc)
              if body_rng.rand(2)==0
                element(
                  "circle",
                  cx:cx, cy:cy, r:cr,
                  **fill(color)
                )
              else
                element(
                  "circle",
                  cx:cx, cy:cy, r:cr,
                  **stroke( color, 1.0/20)
                )
              end
            }
          }
        ]
      end

      def unit(theta)
        rot = "rotate(#{theta*180/Math::PI},0.5,0.5)"
        element("g", transform:rot ){
          body(theta, body_seed)
        }
      end

      def create
        basecol = rainbow(rng.rand(Math::PI*2), ->(v){ (v+3)/4.0 } )
        [
          element("circle", cx:0.5, cy:0.5, r:0.4, **fill(basecol) )
        ]+Array.new(count){ |ix|
          unit(Math::PI*2*ix/count)
        }.flatten
      end
    end
  end
end

