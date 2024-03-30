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
    let(:player) { Player.new('Player1', 1000) }
  
    describe '#initialize' do
      it 'initializes a player with id and money' do
        expect(player.id).to eq('Player1')
        expect(player.money).to eq(1000)
      end
  
      it 'initializes a player with an empty hand and not folded' do
        expect(player.hand).to eq([])
        expect(player.folded).to be false
      end
    end
  
    describe '#place_bet' do
      context 'when the bet amount is valid' do
        it 'reduces the player money by the bet amount' do
          player.place_bet(200)
          expect(player.money).to eq(800)
        end
      end
    end
  
    describe '#fold' do
      it 'sets the player status to folded' do
        player.fold
        expect(player.folded).to be true
      end
    end
  
    describe '#call' do
      it 'reduces the player money by the call amount' do
        player.call(100)
        expect(player.money).to eq(900)
      end
  

    end
  
    describe '#see' do
      context 'when the player has enough money' do
        it 'places the bet and returns true' do
          expect(player.see(100)).to be true
          expect(player.money).to eq(900)
        end
      end
  
      context 'when the player does not have enough money' do
        it 'does not place the bet and returns false' do
          player2 = Player.new('Player2', 50)
          expect(player2.see(100)).to be false
          expect(player2.money).to eq(50)  # Money remains unchanged
        end
      end
    end
  
    describe '#raise' do
      it 'increases the bet and reduces the player money' do
        expect(player.raise(100, 200)).to eq(300)  # total bet is current_bet + added_amount
        expect(player.money).to eq(700)  # 1000 - 300
      end
    end
  
end


RSpec.describe Game do
    let(:player1) { "Player1" }
    let(:player2) { "Player2" }
    let(:player1) { instance_double("Player", folded: false) }
    let(:player2) { instance_double("Player", folded: true) }
    let(:player1) { instance_double("Player", :id => "Player1", :folded => false, :money => 1000) }
    let(:player2) { instance_double("Player", :id => "Player2", :folded => false, :money => 1000) }
    let(:deck) { instance_double("Deck") }
    let(:hand) { instance_double("Hand") }
    let(:game) { Game.new ([player1, player2]) }

    before do
        allow(Deck).to receive(:new).and_return(deck)
        allow(deck).to receive(:shuffle!)
        allow(deck).to receive(:deal).with(5).and_return(hand)
        allow(Player).to receive(:new).with(anything, anything).and_return(player1, player2)
        allow(hand).to receive(:<=>).and_return(0)
    end

  
    describe '#initialize' do
      it 'initializes a game with players' do
        expect(game.players.size).to eq(2)
        
      end
  
      it 'sets up an initial pot and current bet' do
        expect(game.pot).to eq(0)
        expect(game.current_bet).to eq(25)
      end
    end
    describe '#collect_bet' do
        it 'collects bets from all players and adds to pot' do
            allow(player1).to receive(:place_bet).with(Game::FEE).and_return(Game::FEE)
            allow(player2).to receive(:place_bet).with(Game::FEE).and_return(Game::FEE)
            game.collect_bet
            expect(game.pot).to eq(Game::FEE * 2)
        end
    end
    describe '#determine_winner' do
        it 'determines the winner among non-folded players' do
            allow(player1).to receive(:hand).and_return(hand)
            allow(player2).to receive(:hand).and_return(hand)
            expect(game.determine_winner).to eq(player1).or eq(player2)
        end
    end
    
end