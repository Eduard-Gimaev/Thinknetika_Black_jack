require_relative 'card'
require_relative 'deck'
require_relative 'player'
require_relative 'bank'

class Game
  
  def initialize
    @in_play    = false
    @player     = Player.new
    @dealer     = Player.new
    @game_bank  = Bank.new(0)
    @game_ended = false
  end

  def ask_user_name
    while @player.name.to_s.empty? do
      print 'Enter your name: '
      @player.name = gets.chomp
    end
    puts
  end

  def ask_action
    loop do
      show_possible_actions
      begin
        choice = gets.chomp
        case choice
          when '0'  then show_possible_actions
          when '1'  then deal_cards
          when '2'  then hit
          when '3'  then stand
          else
            puts 'Exit'
            break
        end
      rescue => e
        puts "::ERROR:: #{e.message}"
      end
    end
  end

  private

  def show_possible_actions
    puts 'Choose the action from the list below:'
    puts '1 - Distributing cards'
    puts '2 - Taking one more card'
    puts '3 - Passing the move to the Dealer'
    puts '0 - Show menu again'
    puts
  end

  def deal_cards
    check_game_ended

    if in_play?
      # If game started but player chooses a new deal then he looses
      @in_play = false
      @player.reset_cards
      @dealer.reset_cards
      @dealer.bank.replenish(@game_bank.withdraw(@game_bank.amount))  # Dealer takes all game's bank_amount
      show_message('You lost. Chose a new game.')
      show_players_bank_amount
      check_players_empty_bank
    else
      puts '= ' * 50
      puts "The game is running, distributing cards to players..."
      puts '= ' * 50
      puts
      puts "Initial bank at the start of the game:"
      show_players_bank_amount

      # Dealing the initial deck of cards
      @deck = Deck.new
      @deck.shuffle

      [@player, @dealer].map do |p|
        @game_bank.replenish(p.bank.withdraw(10))
        add_cards_to(p, 2)
      end

      @in_play = true

      puts 'All bets are done:'
      show_players_bank_amount
      show_players_cards_and_values
      show_message("Put 2 - Take a card; 3 - Pass the move to the Dealer)")
    end
  end

  def hit
    check_game_ended

    # Add cards to player when he decides to get one more card
    if @player.cards.count < MAX_ALLOWED_CARDS && in_play?
      if @player.get_cards_value <= MAX_SCORE
        @player.add_card(@deck.deal_card)

        show_players_cards_and_values

        if @player.get_cards_value > 21
          @in_play = false
          @player.reset_cards
          @dealer.reset_cards
          @dealer.bank.replenish(@game_bank.withdraw(@game_bank.amount))  # Dealer takes all game's bank_amount
          show_message('You lost!')
          show_players_bank_amount
          check_players_empty_bank
        elsif @player.cards.count >= MAX_ALLOWED_CARDS
          stand # the move switched to Dealer
        end
      end
    else
      show_message("The game has not started yet.") if @player.cards.count >= MAX_ALLOWED_CARDS || !@in_play
    end
  end

  def stand
    check_game_ended

    # Opening cards and count values
    if in_play?
      puts "Dealer's move >>\n\n"

      while @dealer.get_cards_value < 17
        if @dealer.cards.count < MAX_ALLOWED_CARDS
          @dealer.add_card(@deck.deal_card)
        else
          break
        end
      end

      show_players_cards_and_values

      if @dealer.get_cards_value > 21
        @in_play = false
        @player.reset_cards
        @dealer.reset_cards
        @player.bank.replenish(@game_bank.withdraw(@game_bank.amount))  # Player takes all game's bank_amount
        show_message('Dealer lost:)')
      elsif @player.get_cards_value > 21
        @in_play = false
        @player.reset_cards
        @dealer.reset_cards
        @dealer.bank.replenish(@game_bank.withdraw(@game_bank.amount))  # Dealer takes all game's bank_amount
        show_message('You lost!')
      elsif @dealer.get_cards_value == @player.get_cards_value
        half_bank = @game_bank.amount / 2
        @in_play = false
        @player.reset_cards
        @dealer.reset_cards
        @player.bank.replenish(@game_bank.withdraw(half_bank))
        @dealer.bank.replenish(@game_bank.withdraw(half_bank))
        show_message('Draw!')
      elsif @dealer.get_cards_value < @player.get_cards_value
        @in_play = false
        @player.reset_cards
        @dealer.reset_cards
        @player.bank.replenish(@game_bank.withdraw(@game_bank.amount))  # Player takes all game's bank_amount
        show_message('Dealer lost:)')
      else
        @in_play = false
        @player.reset_cards
        @dealer.reset_cards
        @dealer.bank.replenish(@game_bank.withdraw(@game_bank.amount))  # Dealer takes all game's bank_amount
        show_message('Dealer lost!')
      end
      show_players_bank_amount
      check_players_empty_bank
    else
      show_message("The game has not started yet.")
    end
  end

  def in_play?
    @in_play
  end

  def game_ended?
    @game_ended
  end

  def show_message(text)
    puts "#{text}\n\n"
  end

  

  def add_cards_to(player_type, quantity)
    quantity.times { player_type.add_card(@deck.deal_card) }
  end

  def show_players_bank_amount
    puts "#{@player.name} bank: #{@player.bank.amount}"
    puts "Dealer's bank: #{@dealer.bank.amount}"
    puts "Game's bank: #{@game_bank.amount}"
    puts
  end

  def show_players_cards_and_values
    puts "#{@player.name} #{@player}(#{@player.get_cards_value})"
    puts "Dealer's card: #{@dealer.show_cards_as_hidden}(#{@dealer.get_cards_value})"
    puts
  end

  def restart!
    @in_play    = false
    @game_ended = false
    @game_bank.reset
    @player.bank.reset
    @dealer.bank.reset
  end

  def check_game_ended
    if game_ended?
      puts 'The game is over!'
      puts 'Would you like to play again? (Y/N)'
      choice = gets.chomp.downcase

      if choice == 'y'
        restart!
        puts "Restart is done.\n\n"
      else
        puts 'GAME OVER'
        exit(0)
      end
    end
  end

  def check_players_empty_bank
    player_amount = @player.bank.amount
    dealer_amount = @dealer.bank.amount

    if player_amount == 0 && dealer_amount > player_amount
      @game_ended = true
      puts "Dealer won. #{@player.name} bank  empty.\n\n"
    elsif dealer_amount == 0 && player_amount > dealer_amount
      puts "#{@player.name} won. Dealer's bank is empty.\n\n"
      @game_ended = true
    end
    deal_cards
  end

end
