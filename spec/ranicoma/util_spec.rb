# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Ranicoma::Util do
  include Ranicoma::Util

  describe "#element" do
    it "creates Element without attributes" do
      hoge=element("hoge")
      expect( REXML::Element ).to be === hoge
      expect( hoge.name ).to eq("hoge")
      expect( hoge.elements ).to be_empty
    end

    it "creates Element with attributes" do
      hoge=element("hoge", foo:"bar", baz:"qux")
      expect( REXML::Element ).to be === hoge
      expect( hoge.name ).to eq("hoge")
      expect( hoge.attributes.size ).to eq(2)
      expect( hoge.attributes["foo"] ).to eq("bar")
      expect( hoge.attributes["baz"] ).to eq("qux")
    end

    it "creates Element with a child" do
      hoge=element("hoge"){ element("fuga") }
      expect( REXML::Element ).to be === hoge
      expect( hoge.name ).to eq("hoge")
      expect( hoge.children.size ).to eq(1)
      expect( hoge.children[0].name ).to eq("fuga")
    end

    it "creates Element with chlidren" do
      hoge=element("hoge"){[ element("fuga"), element("piyo") ]}
      expect( REXML::Element ).to be === hoge
      expect( hoge.name ).to eq("hoge")
      expect( hoge.children.size ).to eq(2)
      expect( hoge.children[0].name ).to eq("fuga")
      expect( hoge.children[1].name ).to eq("piyo")
    end
  end
end
