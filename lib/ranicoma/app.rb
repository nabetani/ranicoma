# frozen_string_literal: true

require 'optparse'

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
      c=Creator.new(seed, option[:size])
      c.create
      c.write_to($stdout)
    end
  end
end
