require 'spec_helper'
require_relative '../lib/cardpoker'

RSpec.describe Card do
    it "have value of suit" do 
        card = Card.new('Spade', 2)
        expect(card.suit).to eq("Spade")
        expect(card.value).to eq(2)
    end
    
    it "have value of suit" do 
        card = Card.new('Diamond', 4)
        expect(card.suit).to eq("Diamond")
        expect(card.value).to eq(4)
    end

end
RSpec.describe Deck do
    describe "#intialize" do
        it "have 52 cards" do
            @deck = Deck.new
            expect(@deck.instance_variable_get(:@cards).count).to eq(52)
        end
    end
    describe "#shuffle!" do
        it"has different order of cards" do
            @deck = Deck.new
            @deck1 = Deck.new
            expect(@deck.cards[0]).not_to eq(@deck1.cards[0])
        end
    end

    describe "#deal" do
        it "deals 5 cards and remain cards" do 
            current = @deck.instance_variable_get(:@cards).count
            deal = @deck.deal(5)
            expect(deal.count)to eq(5)
            expect(current = @deck.instance_variable_get(:@cards).count)to eq(current - deal)
        end 
    end

end
