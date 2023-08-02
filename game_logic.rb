require_relative 'constants'
require_relative 'card'
require_relative 'deck'
require_relative 'player'
require_relative 'bank'

class Game
  include Constants
  
  def initialize
    @in_play    = false
    @player     = Player.new
    @dealer     = Player.new
    @game_bank  = Bank.new(0)
    @game_ended = false
  end

  def ask_user_name
    puts 'Enter your name: '
    @player.name = gets.chomp
  end

  def ask_action
    loop do
      show_menu
      begin
        choice = gets.chomp
        case choice
          when '0'  then show_menu
          when '1'  then deal_cards
          when '2'  then take_card
          when '3'  then stand
          when 'exit' then exit
        end
      rescue => e
        puts "::ERROR:: #{e.message}"
      end
    end
  end

  private

  def show_menu
    puts 'Choose the action from the list below:'
    puts '0 - Show menu'
    puts '1 - Deal cards'
    puts '2 - Take a card'
    puts '3 - Pass the move to the Dealer'
    puts
  end

  def deal_cards
    #check_game_ended
    @in_play = true
    puts 'All bets have been done:'
    show_banks
    show_cards_and_values
    puts "Put 2 - Take a card; 3 - Pass the move to the Dealer)"
  end

  def show_banks
    puts "#{@player.name} bank: #{@player.bank.amount}"
    puts "Dealer's bank: #{@dealer.bank.amount}"
    puts "Game's bank: #{@game_bank.amount}"
    puts
  end

  def show_cards_and_values
    puts "#{@player.name}'s cards #{@player.show_cards} - (#{@player.get_cards_value})"
    puts "Dealer's card: #{@dealer.show_cards_as_hidden} - (#{@dealer.get_cards_value})"
    puts
  end









  def take_card
    check_game_ended
    # Add cards to player when he decides to get one more card
    if @player.cards.count < MAX_ALLOWED_CARDS && in_play?
      if @player.get_cards_value <= MAX_SCORE
        @player.add_card(@deck.give_card)

        show_players_cards_and_values

        if @player.get_cards_value > 21
          @in_play = false
          @player.reset_cards
          @dealer.reset_cards
          @dealer.bank.replenish(@game_bank.withdraw(@game_bank.amount))  # Dealer takes all game's bank_amount
          puts "You lost!"
          show_players_bank_amount
          check_players_empty_bank
        elsif @player.cards.count >= MAX_ALLOWED_CARDS
          stand # the move switched to Dealer
        end
      end
    else
      puts "The game has not started yet." if @player.cards.count >= MAX_ALLOWED_CARDS || !@in_play
    end
  end

  def stand
    check_game_ended
    # Opening cards and count values
    if in_play?
      puts "Dealer's move >>\n\n"

      while @dealer.get_cards_value < 17
        if @dealer.cards.count < MAX_ALLOWED_CARDS
          @dealer.add_card(@deck.give_card)
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
        puts "Dealer lost:)"
      elsif @player.get_cards_value > 21
        @in_play = false
        @player.reset_cards
        @dealer.reset_cards
        @dealer.bank.replenish(@game_bank.withdraw(@game_bank.amount))  # Dealer takes all game's bank_amount
        puts "You lost!"
      elsif @dealer.get_cards_value == @player.get_cards_value
        half_bank = @game_bank.amount / 2
        @in_play = false
        @player.reset_cards
        @dealer.reset_cards
        @player.bank.replenish(@game_bank.withdraw(half_bank))
        @dealer.bank.replenish(@game_bank.withdraw(half_bank))
        puts "Stand-off!"
      elsif @dealer.get_cards_value < @player.get_cards_value
        @in_play = false
        @player.reset_cards
        @dealer.reset_cards
        @player.bank.replenish(@game_bank.withdraw(@game_bank.amount))  # Player takes all game's bank_amount
        puts "Dealer lost:)"
      else
        @in_play = false
        @player.reset_cards
        @dealer.reset_cards
        @dealer.bank.replenish(@game_bank.withdraw(@game_bank.amount))  # Dealer takes all game's bank_amount
        puts "Dealer lost!"
      end
      show_players_bank_amount
      check_players_empty_bank
    else
      puts "The game has not started yet."
    end
  end

  def in_play?
    @in_play
  end

  def game_ended?
    @game_ended
  end

  def add_cards_to(player_type, quantity)
    quantity.times { player_type.add_card(@deck.give_card) }
  end


  def restart!
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
