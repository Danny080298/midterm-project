require 'spec_helper'
require_relative '../lib/cardpoker'

RSpec.describe Card do
    it "suit" do 
        expect(suit).to eq("Spade")
        expect(value).to eq("2")
    end
    
    
end
