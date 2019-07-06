# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Ranicoma::Util do
  class T
    include Ranicoma::Util
  end

  describe "#element" do
    it "creates REXML::Element Object" do
      hoge=T.new.element("hoge")
      expect( hoge.name ).to eq("hoge")
      expect( hoge.elements ).to be_empty
    end
  end
end
