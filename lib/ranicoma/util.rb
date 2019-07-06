require 'rexml/document'

module Ranicoma
  module Util
    def element(name, opt={})
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
  end
end
