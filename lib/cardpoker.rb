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
    def royal_flush?
        flush? && straight? && @cards.map { |card| card_value(card.value) }.include?(14) && @cards.map { |card| card_value(card.value) }.min == 10
    end

    #straight flush
    def straight_flush?
        flush? && straight?
    end

    #four of a kind
    #full house
    #flush
    def flush?
        @cards.map(&:suit).uniq.size == 1
    end

    #straight
    def straight?
        values = @cards.map { |card| card_value(card.value) }.sort
        values.each_cons(2).all? { |first, second| second == first + 1 }
    end

    #three of a kind
    #two pair 
    #one pair
    #high card

    def card_value(value)
        ranks = {'2' => 2, '3' => 3, '4' => 4, '5' => 5, 
        '6' => 6, '7' => 7, '8' => 8, '9' => 9, '10' => 10, 
        'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14}
        rank = ranks[value]
        
        unless rank
          puts "Unexpected card value: #{value}. Please check the card values."
          rank = 0
        end
       
        rank
    end
end


cards = [Card.new("Hearts", "10"), Card.new("Hearts", "Jack"), Card.new("Hearts", "Queen"), Card.new("Hearts", "King"), Card.new("Hearts", "Ace")]

hand = Hand.new(cards)

puts "this is flush hand #{hand.flush?} "
puts "this is straight hand #{hand.straight?} "
puts "this is straight flush hand #{hand.straight_flush?}"
puts "this is royal straight flush hand #{hand.royal_flush?}"