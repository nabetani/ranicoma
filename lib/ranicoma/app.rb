# frozen_string_literal: true

require 'optparse'

module Ranicoma
  SEED_BASE = 0xf759b389697d7dd4a0cfe8743f6f5e46fb8eed024312b9dff20c1750b920ba
  class App
    def get_option
      OptionParser.new do |opt|
        opt.on("-s", "--size VALUE", 'size in pix (required)', Numeric)
        opt.on("--seed VALUE", 'random number seed', Integer)
        opt.on("-c", "--count VALUE", "number of SVG icons to create", Integer)
        o={}
        opt.permute(ARGV, into:o)
        return o
      end
    end

    def run
      option=get_option
      seed0 = option[:seed] || Random.new_seed
      (option[:count]||1).times do |x|
        seed=SEED_BASE*x + seed0
        c=Creator.new(seed, option[:size])
        c.create
        c.write_to($stdout)
      end
    end
  end
end
