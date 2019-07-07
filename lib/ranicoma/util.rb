require 'rexml/document'

module Ranicoma
  module Util
    # REXML::Element を作る
    # @param [Object] name タグ名。to_s で文字列にされる。
    # @param [Hash] opt アトリビュート。key も value も to_s で文字列にされる
    # @yield [] 子要素作るブロック
    # @yieldreturn [REXML::Element, Array<REXML::Element>] 子要素または子要素の配列
    # @return [REXML::Element] XML Element。
    def element(name, opt={})
      r=opt.each.with_object(REXML::Element.new(name)) do |(k,v),e|
        e.add_attribute(k.to_s, v.to_s)
      end
      if block_given?
        children = yield
        if children.is_a?(Array)
          children.flatten.each do |ch|
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
