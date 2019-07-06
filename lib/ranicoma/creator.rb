# frozen_string_literal: true

require 'rexml/document'
require "ranicoma/util"

module Ranicoma
  class Creator
    include Util
    def initialize( seed, size )
      @rng=Random.new(seed)
      @size=size
      @doc = REXML::Document.new
      @doc << REXML::XMLDecl.new('1.0', 'UTF-8')
    end
    attr_reader(:rng)
    attr_reader(:size)
    attr_reader(:doc)

    def create
      design = Design::Base.subclasses.sample( random:rng ).new(rng)
      doc << (
        element("svg", xmlns:"http://www.w3.org/2000/svg", height:"#{size}px", width:"#{size}px", viewBox:"0 0 1 1" ){
          design.create
        }
      )
    end
  end
end

