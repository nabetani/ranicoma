# frozen_string_literal: true

require 'optparse'
require 'rexml/formatters/pretty'

module Ranicoma
  class App
    def get_option
      OptionParser.new do |opt|
        opt.on("--size VALUE", 'size in pix (required)', Numeric)
        opt.on("--seed VALUE", 'random number seed', Integer)
        o={}
        opt.permute(ARGV, into:o)
        return o
      end
    end

    def run
      option=get_option
      seed = option[:seed] || Random.new_seed
      size = option[:size] || 100
      formatter = REXML::Formatters::Pretty.new
      c=Ranicoma::Creator.new(seed, size)
      formatter.write(c.create, $stdout)
    end
  end
end
