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
        context "when a new deck is created" do
            it "have 52 cards" do
                deck = Deck.new
                expect(deck.cards.count).to eq(52)
            end
        end
    end
    describe "#shuffle!" do
        context "when the deck is shuffled" do

            it"has different order of cards" do
                @deck = Deck.new
                @deck1 = Deck.new
                expect(@deck.cards).not_to eq(@deck1.cards)
            end
        end
    end

    describe "#deal" do
        context 'Dealing 5 cards and display remain cards' do
            it "deals 5 cards and remain cards" do 
                deck = Deck.new

                expect { deck.deal(5) }.to change { deck.cards.count }.by(-5)
            end
        end
    end
end

RSpec.describe Hand do
    describe '#flush?' do
      context 'when the hand is a flush' do
        it 'returns true' do
          cards = [Card.new("Hearts", "10"), 
                   Card.new("Hearts", "3"), 
                   Card.new("Hearts", "2"), 
                   Card.new("Hearts", "6"),
                   Card.new("Hearts", "9")]
          hand = Hand.new(cards)
          expect(hand.flush?).to eq true
        end
      end
    end
    describe "#staight?" do 
        context 'when the hand is straight' do
            it 'return true' do
                cards = [Card.new("Clubs", "2"), 
                        Card.new("Hearts", "3"), 
                        Card.new("Hearts", "4"), 
                        Card.new("Hearts", "5"), 
                        Card.new("Hearts", "6")]
                hand = Hand.new(cards)
                expect(hand.straight?).to eq true
            end
        end
    end

    describe "#straight_flush?" do
        context 'when the hand is straight flush' do
            it 'return true' do
                cards = [Card.new("Hearts", "2"), 
                        Card.new("Hearts", "3"), 
                        Card.new("Hearts", "4"), 
                        Card.new("Hearts", "5"), 
                        Card.new("Hearts", "6")]
                hand = Hand.new(cards)
                expect(hand.straight_flush?).to eq true
            end
        end
    end
    describe "#royal_flush?" do
        context 'when the hand is royal flush' do
            it 'return true' do
                cards = [Card.new("Hearts", "10"), 
                        Card.new("Hearts", "Jack"), 
                        Card.new("Hearts", "Queen"), 
                        Card.new("Hearts", "King"), 
                        Card.new("Hearts", "Ace")]
                hand = Hand.new(cards)
                expect(hand.royal_flush?).to eq true
            end
        end
    end
    describe "#four_of_a_kind?" do
        context "when the hand is four of a kind" do
            it "return true" do
                cards = [Card.new("Hearts", "10"), 
                        Card.new("Clubs", "10"), 
                        Card.new("Spades", "10"), 
                        Card.new("Diamonds", "10"), 
                        Card.new("Hearts", "Ace")]
                hand = Hand.new(cards)
                expect(hand.four_of_a_kind?).to eq true
            end
        end
    end
    describe "#three_of_a_kind?" do
        context "when the hand is three of a kind" do
            it "return true" do
                cards = [Card.new("Hearts", "10"), 
                        Card.new("Clubs", "10"), 
                        Card.new("Spades", "10"), 
                        Card.new("Diamonds", "4"), 
                        Card.new("Hearts", "Ace")]
                hand = Hand.new(cards)
                expect(hand.three_of_a_kind?).to eq true
            end
        end
    end
    describe "#two_pair?" do
        context "when the hand is two pair" do
            it "return true" do
                cards = [Card.new("Hearts", "10"), 
                        Card.new("Clubs", "10"), 
                        Card.new("Spades", "4"), 
                        Card.new("Diamonds", "4"), 
                        Card.new("Hearts", "Ace")]
                hand = Hand.new(cards)
                expect(hand.two_pair?).to eq true
            end
        end
    end
   
    describe "#pair?" do
        context "when the hand is a pair" do
            it "return true" do
                cards = [Card.new("Hearts", "10"), 
                        Card.new("Clubs", "10"), 
                        Card.new("Spades", "4"), 
                        Card.new("Diamonds", "5"), 
                        Card.new("Hearts", "9")]
                hand = Hand.new(cards)
                expect(hand.pair?).to eq true
            end
        end
    end
    describe "#full_house?" do
        context "when the hand is full house" do
            it "return true" do
                cards = [Card.new("Hearts", "10"), 
                        Card.new("Clubs", "10"), 
                        Card.new("Spades", "4"), 
                        Card.new("Diamonds", "4"), 
                        Card.new("Hearts", "4")]
                hand = Hand.new(cards)
                expect(hand.full_house?).to eq true
            end
        end
    end
    describe "#high_card?" do
        context "When the hand have nothing related" do
            it "return the highest card" do
                cards = [Card.new("Hearts", "10"), 
                        Card.new("Spades", "5"), 
                        Card.new("Hearts", "6"), 
                        Card.new("Spades", "Ace"), 
                        Card.new("Hearts", "King")]
                hand = Hand.new(cards)
                high_card = hand.high_card?
                expect(high_card.suit).to eq "Spades"
                expect(high_card.value).to eq "Ace"
             end
        end
    end
    describe "#high_card?" do
        context "when 2 hands have a tiebreaker and a kicker" do
            it "return the highest card" do
                cards1 = [Card.new("Hearts", "10"), 
                        Card.new("Spades", "10"), 
                        Card.new("Hearts", "Queen"), 
                        Card.new("Spades", "Queen"), 
                        Card.new("Hearts", "King")]
                
                cards2 = [Card.new("Diamonds", "10"), 
                        Card.new("Clubs", "10"), 
                        Card.new("Clubs", "Queen"), 
                        Card.new("Diamonds", "Queen"), 
                        Card.new("Hearts", "Ace")]
                                
                hand1 = Hand.new(cards1)
                hand2 = Hand.new(cards2)
                expect(hand1).to be < hand2

            end
            it 'confirms hand2 is greater than hand1' do
                cards1 = [Card.new("Hearts", "10"), 
                        Card.new("Spades", "10"), 
                        Card.new("Hearts", "Queen"), 
                        Card.new("Spades", "Queen"), 
                        Card.new("Hearts", "King")]
                
                cards2 = [Card.new("Diamonds", "10"), 
                        Card.new("Clubs", "10"), 
                        Card.new("Clubs", "Queen"), 
                        Card.new("Diamonds", "Queen"), 
                        Card.new("Hearts", "Ace")]
                                
                hand1 = Hand.new(cards1)
                hand2 = Hand.new(cards2)
                comparison_result = hand1 <=> hand2
                expect(comparison_result).to be_negative
            end
        end
    end
end

RSpec.describe Player do
    describe "#fold" do
        context "the player gave up" do
            it "the player is fold" do
                hand = [Card.new('Hearts', '10'), 
                Card.new('Spades', 'Ace')]
                player = Player.new(hand, 100)

                expect(player.is_active).to eq true
                player.fold
                expect(player.is_active).to eq false
            end
        end
    end
    describe '#discard_and_draw' do
        let(:deck) { Deck.new } # Ensure this setup matches your actual Deck class
        let(:initial_hand) { deck.deal(5) }
        let(:player) { Player.new(initial_hand, 100) }
        context"Discard and draws" do
            it 'updates the player hand after discarding and drawing' do
                original_hand = player.hand.dup
                allow(player).to receive(:gets).and_return("1 3 5\n")
                allow(deck).to receive(:deal).with(3).and_return([Card.new('Diamonds', '2'), Card.new('Hearts', '3'), Card.new('Clubs', '4')])

                expect { player.discard_and_draw([1, 3, 5], deck) }.to change { player.hand }
                expect(player.hand).not_to match_array(original_hand)
                   
            end
        end
    end

end