# frozen_string_literal: true

require 'rexml/document'

module Ranicoma
  class Creator
    def initialize( seed, size )
      @rng=Random.new(seed)
      @size=size
      @doc = REXML::Document.new
      @doc << REXML::XMLDecl.new('1.0', 'UTF-8')
    end
    attr_reader(:rng)
    attr_reader(:size)
    attr_reader(:doc)

    def element(name, opt)
      r=opt.each.with_object(REXML::Element.new(name)) do |(k,v),e|
        e.add_attribute(k.to_s, v.to_s)
      end
      if block_given?
        children = yield
        if children.is_a?(Array)
          children.each do |ch|
            r.add_element(ch)
          end
        else
          r.add_element(children)
        end
      end
      r
    end

    def create
      doc << (
        element("svg", xmlns:"http://www.w3.org/2000/svg", height:"#{size}px", width:"#{size}px", viewBox:"0 0 1 1" ){
          element("rect", height:1, width:1, style:"fill:rgb(255,0,0)")
        }
      )
    end

    def write_to(io)
      doc.write(io, 2)
      io.puts
    end
  end
end

