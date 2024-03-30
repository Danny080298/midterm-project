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
    attr_accessor :hand, :money, :folded
    attr_reader :id


    def initialize(id, money)
        @id = id
        @money = money
        @hand = []
        @folded = false
    end


    def place_bet(amount)
        raise "Invalid amount" if @money < amount
        @money -= amount
    end

    def prize(amount)
        @money += amount
    end

    def discard_card(card_posit)
        @hand.discard_by_positions(card_posit)
    end
    #to do list

    #discard and draw
    def discard_and_draw(positions, deck)
        puts "#{@id} your current hand is: " + @hand.cards.map.with_index(1) { |card| "#{card}" }.join(', ')

        num_card = 0
        loop do
            puts "How many cards to discard? (0 - 3)"
            num_card = gets.chomp.to_i

            if num_card.between?(0,3)
                break
            else
                puts"Try again!"
            end
        end

        discard_posit = []
        if num_card > 0
            puts"Please enter #{num_card== 1 ? 'the number' : 'each number'} of the card(s) you wish to discard, separated by spaces (e.g., 1 3): "


            while discard_posit.empty?
                input_card = gets.chomp.split.map(&:to_i).map { |num|num-1}.uniq

                if input_card.length == num_card && input_card.all? {|index|index.between?(0, @hand.cards.length - 1 )}
                    discard_posit = input_card
                else
                    puts "Invalid input, try again"

                end
            end
        end
        discard_posit 
    end


    #fold
    
    def fold
        @folded = true
    end

    def call(bets)
        raise "Invalid amount to call" if bets > @money
        @money -= bets
    end

    #see
    def see(current_bet)
        if @money >= current_bet
            place_bet(current_bet)
            true
        else
            false
        end
    end

    #raise
    def raise(current_bet, added_amount)
        total_bet = current_bet + added_amount
        raise "Invalid amount" if @money < total_bet
        @money -= total_bet
        total_bet
    end

end   

class Game
    attr_reader :players, :deck 
    attr_accessor :pot, :current_bet

    FEE = 25

    def initialize(players, money = 2000)
        @players = players.map { |player_id| Player.new(player_id, money) }
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
            puts "======================================"
            puts "#{player.id}'s Money: #{player.money}"
        end
    end

    #ask player discard and draw
    def players_discard_and_draw
        @players.each do |player|
            puts "\n#{player.id}, it's your turn to discard and draw."
  
            card_positions_to_discard = [] # This would be determined based on player input or strategy
            new_cards = @deck.deal(card_positions_to_discard.length) # Assuming we have a Deck instance
            player.discard_and_draw(card_positions_to_discard, @deck)
        
            player.hand.cards.concat(new_cards)
            puts "#{player.id}, your new hand is: #{player.hand.cards.map(&:to_s).join(', ')}"
          
            next_player(player)  # Invoke post-discard actions here
        end
    end
    #collect bet(fee)
    def collect_bet
        @players.each do |player|
            @pot += player.place_bet(FEE)
        end
    end

    #deal cards
    def deal_cards
        @deck.shuffle!
        @players.each { |player| player.hand = Hand.new(@deck.deal(5)) }
    end
    
    #determine the winner

    def determine_winner
        remain_players = @players.reject(&:folded)
        win_player = remain_players.max do |player1, player2|
            player1.hand <=> player2.hand
        end
        win_player
    end
    def prize
        winner = determine_winner
        if winner
            winner.money += @pot
            puts "#{winner.id} win the prize of $#{@pot}"
            @pot = 0
        else
            puts "No winner could be found"
        end
    end

    
    #restart the game
    def start 
        loop do
            collect_bet
            deal_cards
            players_discard_and_draw
            prize
            take_turns
        end
    end
    def restart
        @deck = Deck.new
        @deck.shuffle!
        @players.each do |player|
            player.hand = []

            player.folded = false
        end
        @pot = 0
        @current_bet = 0

    end
    private

    def next_player(player)
        return if player.folded
        valid_action = false
        until valid_action
            puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            puts "#{player.id}, would you like to 1: Call, 2: Raise, 3: Fold ???"
            action = gets.chomp.downcase
            case action
            when '1'
                if player.money >= @current_bet
                    player.money -= @current_bet
                    @pot += @current_bet
                    puts "#{player.id}calls with #{current_bet}"
                else
                    puts "No enough bet to call. Folded turn"
                    player.fold
                end
                valid_action = true
            when '2'
                puts "Current bet is #{@current_bet}. How much do you want to raise? "
                raise_money = gets.to_i
                if raise_money > 0 && player.money >= (@current_bet +raise_money)
                    player.money -= (@current_bet + raise_money)
                    @pot += (@current_bet + raise_money) 
                    @current_bet += raise_money
                    puts "#{player.id} raises to #{@current_bet}."
                    puts "******Current pot is #{current_bet}******"

                else
                    puts " Invalid amount, folded turn"
                    player.fold
                end
                valid_action = true
            when '3'
                player.fold

                puts "#{player.id} has folded."
                valid_action = true
            else
                puts "Invalid input, try again"
            end
        end
    end

end
players = [Player.new(1, 1000), Player.new(2, 1000)] 
game = Game.new(players)

game.start

game.take_turns