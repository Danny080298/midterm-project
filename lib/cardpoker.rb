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
    def to_s
        @cards.map { |card| "#{card.value} of #{card.suit}" }.join(', ')
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
        @cards.map { |card| "#{card.value} of #{card.suit}" }.join(', ')
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
            high_card?<=> other_hand.high_card
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

    def discard_by_positions(positions)
        positions.sort.reverse.each { |pos| @cards.delete_at(pos - 1) }
    end

    def rank
        card_ranks = @cards.map { |card| card_value(card.value) }
        card_ranks.max
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
        values = {'2' => 2, '3' => 3, '4' => 4, '5' => 5, 
        '6' => 6, '7' => 7, '8' => 8, '9' => 9, '10' => 10, 
        'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14}
        
        values[value] || 0
        
        # unless rank
        #   puts "Unexpected card value: #{value}. Please check the card values."
        #   rank = 0
        # end
       
        # rank
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

class Player
    attr_accessor :hand, :pot, :current_bet
    attr_reader :is_active
    def initialize(hand, pot)
        @hand = hand
        @pot = pot
        @is_active = true
        @current_bet = 0
    end
    def to_s
        hand_description = @hand.map { |card| "#{card.value} of #{card.suit}" }.join(', ')
        "Hand: #{hand_description}"
        "Pot: #{@pot}"
    end
    #to do list
    #discard and draw
    def discard_and_draw(positions, deck)
        puts "Hand: #{hand_to_s}"
        puts "Enter the positions of the cards you wish to discard (e.g., 3 cards to discard the first and third cards):"
        input = gets.chomp
        discard_positions = input.split.map(&:to_i)
        discard_cards(discard_positions)
        draw_new_cards(discard_positions.size, deck)
        puts "New hand: #{hand_to_s}"
    end
    #fold
    def fold
        @is_active = false
    end


    #see
    def see(current_bet_amount)
        amount_needed_to_call = current_bet_amount - @current_bet
    
        if amount_needed_to_call <= @pot
            @pot -= amount_needed_to_call
            @current_bet = current_bet_amount
            puts "Player calls and matches the current bet of #{current_bet_amount}. Remaining chip stack: #{@chip_stack}."
        else
            puts "Player cannot cover the bet of #{current_bet_amount} with only #{@chip_stack} in the chip stack."
            fold
        end
    end
    def raise_bet(amount_to_raise)
        total_bet = @current_bet + amount_to_raise

        if amount_to_raise <= 0
            puts "Raise amount must be more than 0."
        elsif total_bet > @pot
            puts "Insufficient funds to raise. You have #{@pot}, but need #{total_bet}."
        else
          puts "Player cannot cover the bet of #{current_bet} with only #{@pot} in the pot."
          fold
            @pot -= amount_to_raise
            @current_bet = total_bet
            puts "Player raises the bet to #{total_bet}. Remaining pot: #{@pot}."
        end
    end

    private
    
    def discard_cards(positions)
        positions.sort.reverse.each { |pos| @hand.delete_at(pos - 1) }
    end
    def draw_new_cards(number, deck)
        new_cards = deck.deal(number)
        @hand.concat(new_cards)
    end
    def hand_to_s
        @hand.map { |card| "#{card.value} of #{card.suit}" }.join(', ')
    end

end   

class Game
    attr_reader :player, :deck 
    attr_accessor :pot, :current_bet

    FEE = 25

    def intialize(id, money = 2000)

        @players = id.map {|id|Player.new(id, money)}
        @deck = Deck.new
        @pot = 0
        @current_bet = FEE
    end


    #list to do
    #take turns for each player
    def take_turns
        puts "Pot: #{@pot}"
        @players.each do |player|
            hand_player = if player.fold
                "Folded"
            else
                "#{player.hand.cards.map(&:to_s).join(', ')}"
            end
            puts "#{player.id}'s hand: #{hand_player}"
            puts "#{player.id}'s chip stack: #{player.money}"
        end
    end
    def players_discard_and_draw
        @players.each do |player|
          puts "\n#{player.id}, it's your turn to discard and draw."
          cards_to_discard = player.decide_cards_to_discard
          player.discard_cards(cards_to_discard)
          new_cards = @deck.deal(cards_to_discard.length)
          player.hand.cards.concat(new_cards)
          puts "#{player.id}, your new hand is: #{player.hand.cards.map(&:to_s).join(', ')}"
          
          post_discard_action(player)  # Invoke post-discard actions here
        end
    end
    #collect bet(fee)
    #deal cards
    def deal_cards
        @deck.shuffle!
        @players.each { |player| player.hand = Hand.new(@deck.deal(5)) }
    end
    #ask player discard and draw
    #determine the winner
    #restart the game


end
