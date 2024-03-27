class Card
    attr_reader :suit, :value

    def initialize(suit, value)
        @suit, @value = suit, value
    end
    def to_s
        "#{@value} of #{@suit}"
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
    
end


deck = Deck.new
deck1 = Deck.new 
if deck.cards.length == 52
    puts "let play"
else
    puts "Get a new deck"
end
if "#{deck.cards.first}" != "#{deck1.cards.first}"
    puts "Your hand is"
    puts"#{deck.cards[0]} and #{deck.cards[1]} and #{deck.cards[2]},#{deck.cards[3]}, #{deck.cards[4] }"
else
    puts "This deck is not shuffled"
end