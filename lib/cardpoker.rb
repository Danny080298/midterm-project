class Card
    attr_reader :suit, :value

    def initialize(suit, value)
        @suit, @value = suit, value
    end
    def to_s
        "#{@value} #{@suit}"
    end

end


class Deck
    SUITS = %w[Hearts Diamonds Clubs Spades]
    VALUES = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace]
    attr_reader :cards

    def initialize
        @cards = SUITS.product(VALUES).map { |suit, value| Card.new(suit, value) }
        shuffle!
    end
    def shuffle!
        @cards.shuffle!
    end
    
    def deal(number)
        @cards.pop(number)
    end
end

class Hand

    attr_reader :cards

    def initialize(cards)
        @cards = cards
    end
    def to_s
        card_descriptions = @cards.map { |card| "#{card.value} of #{card.suit}" }.join(', ')
        "Hand contains: #{card_descriptions}"
    end

    #best rank
    #royal straight flush
    #straight flush
    #four of a kind
    #full house
    #flush
    def flush?
        @cards.map(&:suit).uniq.size == 1
    end
    #straight
    #three of a kind
    #two pair 
    #one pair
    #high card
end


cards = [Card.new("Hearts", "10"), Card.new("Hearts", "3"), Card.new("Hearts", "2"), Card.new("Hearts", "6"), Card.new("Hearts", "9")]

hand = Hand.new(cards)

puts "this is flush hand #{hand.flush?} "