require_relative 'poker_cards'
require_relative 'poker_hand'


class Poker
  HAND_CHECKS = [:high_card, :pair?, :two_pair?, :three?, :straight?,
                 :flush?, :full_house?, :four?, :straight_flush?]

  def initialize
    @deck = Deck.new
    @players = []
    @current_pot = 0
  end

  def play
    set_players
    set_player_names

    reset_pot_and_bets
    play_betting_round
    play_exchange_round
    play_betting_round
    send_in_bets

    determine_winner

  end

  def reset_pot_and_bets
    @current_pot = 0
    @players.each { |player| player.current_bet = 0 }
  end

  def play_betting_round
    ready = false

    until ready
      @players.each do |player|
        next if player.fold

        puts "\n\n#{player.name}'s turn, currently in for $#{player.current_bet || 0}"
        player.show_hand
        if @current_pot == 0
          puts "Would you like to bet or check?"
          puts "Enter 0 to check, or bet amount to bet."
          @current_pot += gets.chomp.to_i
          player.current_bet = @current_pot
        else
          decision = catch(:decided) do
            loop do
              puts "Would you like to check at #{@current_pot}, raise, or fold?"
              puts "Enter 'c' to check, 'r' to raise, 'f' to fold."
              decided = gets.chomp.downcase
              throw(:decided, decided) if decided =~ /[crf]/i
            end
          end

          case decision
          when 'c'
            player.current_bet = @current_pot
          when 'r'
            puts "How much would you like to raise?"
            amount = gets.chomp.to_i
            @current_pot += amount
            player.current_bet = @current_pot
          when 'f'
            player.fold = true
          end
        end
      end

      ready = true if @players.all? { |player| player.current_bet == @current_pot || player.fold}
    end

    self
  end

  def send_in_bets
    @players.each do |player|
      player.bet(player.current_bet)
    end

    self
  end

  def play_exchange_round
    @players.each do |player|
      next if player.fold

      card_nums = nil
      exchange_cards = catch(:exchange) do
        loop do
          puts "\n\n#{player.name}'s turn, currently in for $#{player.current_bet || 0}"
          player.show_hand
          puts "Enter the card numbers for cards you would like to exchange:"
          puts "Maximum of three cards, (eg 1,2,3), Press enter for no new cards."
          card_nums = gets.chomp
          throw(:exchange, []) if card_nums.empty?

          card_nums = card_nums.split(',').map(&:to_i).map { |c| c - 1 }
          if card_nums.count <= 3 && card_nums.all? { |card| card.between?(0, 4) }
            throw(:exchange, card_nums)
          end
        end
      end

      player.hand.exchange(exchange_cards)
    end
  end

  def determine_winner
    possible_winners = @players.select { |player| !player.fold }

    best_hand_type = possible_winners.map do |player|
      player.hand.score_hand
    end.max

    possible_winners.select! do |player|
      player.hand.score_hand == best_hand_type
    end

    best_value = possible_winners.map do |player|
      player.hand.send(HAND_CHECKS[best_hand_type])
    end.max

    possible_winners.select! do |player|
      player.hand.send(HAND_CHECKS[best_hand_type]) == best_value
    end

    if possible_winners.count <= 1
      winner = possible_winners.first
      puts "#{winner.name} Wins!"
      winner.win_pot(@current_pot)
    else
      resolve_tie(possible_winners, best_hand_type)
    end

    self
  end

  def resolve_tie(winners, hand_type_dex)
    case hand_type_dex

    when 0 || 4 || 5 || 8
      #TODO: flawed for matching high cards, does not trickle down

      puts "Complete Draw!"
      winner_count = winners.count
      winners.each { |player| player.win_pot(@current_pot / winner_count) }

    when 1 || 3 || 7
      #TODO: flawed for case where high card is not a kicker

      winners = []
      high_card = winners.map { |player| player.hand.high_card }.max

      winners.select! { |player| player.hand.high_card == high_card }
      if winners.count <= 1
        winner = winners.first
        puts "#{winner.name} Wins!"
        winner.win_pot(@current_pot)
      else
        resolve_tie(winners, 0)
      end

    when 6
      kicker_pair = winners.map { |player| player.hand.pair? }.max
      winners.select! { |player| player.hand.pair? == kicker_pair }

      if winners.count <= 1
        winner = winners.first
        puts "#{winner.name} Wins!"
        winner.win_pot(@current_pot)
      else
        resolve_tie(winners, 0)
      end

    when 1
      best_low_pair = winners.map do |player|
        card_map = player.hand.cards.map(&:value)
        low = card_map.select { |card| card_map.count(card) == 2 }.min
      end.max

      winners.select! do |player|
        card_map = player.hand.cards.map(&:value)
        card_map.select { |card| card_map.count(card) == 2 }.min == best_low_pair
      end

      if winners.count <= 1
        winner = winners.first
        puts "#{winner.name} Wins!"
        winner.win_pot(@current_pot)
      else
        resolve_tie(winners, 1)
      end
    end

    self
  end

  def set_players
    players = catch(:player_num) do
      loop do
        puts "Please enter the number of players (2-7)."
        player_num = gets.chomp.to_i
        throw(:player_num, player_num) if player_num.between?(2, 7)
      end
    end

    players.times do |play_num|
      @players << Player.new(@deck)
    end

    self
  end

  def set_player_names
    @players.each_index do |i|
      print "Please enter name for Player #{i + 1} > "
      @players[i].name = gets.chomp
    end

    self
  end
end



if $PROGRAM_NAME == __FILE__
  poker = Poker.new
  poker.play
end
