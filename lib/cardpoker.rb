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
    include Comparable
    attr_reader :cards

    def initialize(cards)
        @cards = cards
    end
    def to_s
        card_descriptions = @cards.map { |card| "#{card.value} of #{card.suit}" }.join(', ')
        "Hand contains: #{card_descriptions}"
    end
    
    RANKING = {
        'royal_flush' => 10,
        'straight_flush' => 9,
        'four_of_a_kind' => 8,
        'full_house' => 7,
        'flush' => 6,
        'straight' => 5,
        'three_of_a_kind' => 4,
        'two_pair' => 3,
        'pair' => 2,
        'high_card' => 1
    }.freeze

    def <=>(other_hand)
        check_hand = RANKING[best_rank] <=> RANKING[other_hand.best_rank]
        return check_hand unless check_hand == 0

        case best_rank
        when 'pair','two_pair','three_of_a_kind','four_of_a_kind'
            compare_multiples(other_hand)
        when 'straight','straight_flush','high_card'
            high_card<=> other_hand.high_card
        when 'flush', 'full_house'
            high_card <=> other_hand.high_card
        else
            0
        end
    end

    def group_cards_by_value
        @cards.group_by(&:value)
    end

    def compare_high_card(other_hand)
        our_kickers = @cards.reject { |card| group_cards_by_value[card.value].size > 1 }.max_by { |card| card_value(card.value) }
        other_kickers = other_hand.cards.reject { |card| other_hand.group_cards_by_value[card.value].size > 1 }.max_by { |card| card_value(card.value) }
    
        card_value(our_kickers.value) <=> card_value(other_kickers.value)
    end


    #best rank
    def best_rank
        return 'royal_flush' if royal_flush?
        return 'straight_flush' if straight_flush?
        return 'four_of_a_kind' if four_of_a_kind?
        return 'full_house' if full_house?
        return 'flush' if flush?
        return 'straight' if straight?
        return 'three_of_a_kind' if three_of_a_kind?
        return 'two_pair' if two_pair?
        return 'pair' if pair?
        'high_card'
    end

    #royal straight flush
    def royal_flush?
        flush? && straight? && @cards.map { |card| card_value(card.value) }.include?(14) && @cards.map { |card| card_value(card.value) }.min == 10
    end 

    #straight flush
    def straight_flush?
        flush? && straight?
    end

    #four of a kind
    def four_of_a_kind?
        value_counts = @cards.each_with_object(Hash.new(0)) { |card, counts| counts[card.value] += 1 }
        value_counts.values.include?(4)
    end

    #full house
    def full_house?
        three_of_a_kind? && pair?
    end

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
    def three_of_a_kind?
        value_counts = @cards.each_with_object(Hash.new(0)) { |card, counts| counts[card.value] += 1 }
        value_counts.any? { |_, count| count == 3 }
    end

    #two pair 
    def two_pair?
        value_counts = @cards.each_with_object(Hash.new(0)) { |card, counts| counts[card.value] += 1 }
        value_counts.select { |_, count| count == 2 }.size == 2
    end
    
    #one pair
    def pair?
        value_counts = @cards.each_with_object(Hash.new(0)) { |card, counts| counts[card.value] += 1 }
        value_counts.any? { |_, count| count == 2 }
    end

    #high card
    def high_card?
        @cards.max_by { |card| card_value(card.value) }
    end

    private

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

    def compare_multiples(other_hand)
        our_grouped_cards = group_cards_by_value.sort_by { |value, cards| [-cards.size, card_value(value)] }
        their_grouped_cards = other_hand.group_cards_by_value.sort_by { |value, cards| [-cards.size, card_value(value)] }
    
        our_grouped_cards.each_with_index do |(_, our_cards), index|
          their_value, their_cards = their_grouped_cards[index]
          check_hand = our_cards.size <=> their_cards.size
          return check_hand unless check_hand == 0
          check_hand = card_value(our_cards.first.value) <=> card_value(their_cards.first.value)
          return check_hand unless check_hand == 0
        end
    
        compare_high_card(other_hand)
    end
end


cards1 = [Card.new("Hearts", "10"), Card.new("Spades", "10"), Card.new("Hearts", "Queen"), Card.new("Spades", "Queen"), Card.new("Hearts", "King")]
cards2 = [Card.new("Diamonds", "10"), Card.new("Clubs", "10"), Card.new("Clubs", "Queen"), Card.new("Diamonds", "Queen"), Card.new("Hearts", "Ace")]


hand1 = Hand.new(cards1)
hand2 = Hand.new(cards2)

if hand1 > hand2
    puts "Hand 1 is stronger."
elsif hand1 < hand2
    puts "Hand 2 is stronger."
else
    puts "The hands are equal in strength."
end

puts "The high card of this hand #{hand2.high_card?}"


# puts "this is flush hand #{hand.flush?} "
# puts "this is straight hand #{hand.straight?} "
# puts "this is straight flush hand #{hand.straight_flush?}"
# puts "this is royal straight flush hand #{hand.royal_flush?}"
# puts "this is four of a kind #{hand.four_of_a_kind?}"
# puts "this is three of a kind #{hand.three_of_a_kind?}"
# puts "this is a two pairs #{hand.two_pair?}"
# puts "this is a pair #{hand.pair?}"
# puts "this is full house #{hand.full_house?}"


