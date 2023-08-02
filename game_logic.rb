require_relative 'constants'
require_relative 'card'
require_relative 'deck'
require_relative 'player'
require_relative 'bank'

class Game
  include Constants
  
  def initialize
    @player     = Player.new
    @dealer     = Player.new
    @deck       = Deck.new
    @game_bank  = Bank.new(0)
    @game_ended = false
  end

  def ask_user_name
    while @player.name.empty? do
      print 'Enter your name: '
      @player.name = gets.chomp
    end
  end

  def ask_action
    loop do
      show_menu
      begin
        choice = gets.chomp
        case choice
          when '0' then show_menu
          when '1' then deal_cards
          when '2' then take_card
          when '3' then stand
          when '4' then open_cards
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
    puts '4 - Open cards'
    puts
  end

  def deal_cards
    if @player.cards == [] && @dealer.cards == []
      2.times { @player.cards << @deck.give_card }
      2.times { @dealer.cards << @deck.give_card }
      first_bet
      show_banks
      puts "=" * 30
      show_cards_and_values
      puts "=" * 30
    else
      puts "The game in the process...."

      ask_action
    end
  end

  def show_banks
    puts "#{@player.name} bank: #{@player.bank.amount}"
    puts "Dealer's bank: #{@dealer.bank.amount}"
    puts "Game's bank: #{@game_bank.amount}"
    puts
  end
  def first_bet
    @dealer.bank.withdraw(10)
    @dealer.bank.withdraw(10)
    @game_bank.replenish(20)
  end

  def show_cards_and_values
    puts "#{@player.name}'s cards #{@player.show_cards} - (#{@player.get_cards_value})"
    puts "Dealer's card: #{@dealer.show_cards_as_hidden} - (#{@dealer.get_cards_value})"
    puts
  end

  def take_card
    if @player.cards.count < MAX_ALLOWED_CARDS && @player.get_cards_value <= MAX_SCORE
      @player.add_card(@deck.give_card)
      show_cards_and_values
      if @player.get_cards_value > 21
        puts "You're burned out!"
        dealer_winner
      elsif @player.cards.count >= MAX_ALLOWED_CARDS
      stand # the move switched to Dealer
      end
    else
      puts "Sorry, you cannot take a card"
      puts "=" * 30
    end
  end

  def stand
    puts "Dealer's move >>\n\n"
      if @dealer.get_cards_value < 17 && @dealer.cards.count < MAX_ALLOWED_CARDS
        @dealer.add_card(@deck.give_card)
        show_cards_and_values
        player_winner if @dealer.get_cards_value > 21
      else
        open_cards
      end
  end

  def dealer_winner
    @player.reset_cards
    @dealer.reset_cards
    @dealer.bank.replenish(@game_bank.withdraw(@game_bank.amount))
    puts "Dealer won the game!"
    show_banks
  end

  def player_winner
    @player.reset_cards
    @dealer.reset_cards
    @player.bank.replenish(@game_bank.withdraw(@game_bank.amount))
    puts "Player won the game!"
    show_banks
  end

  def stand_off
    half_bank = @game_bank.amount / 2
    @player.reset_cards
    @dealer.reset_cards
    @player.bank.replenish(@game_bank.withdraw(half_bank))
    @dealer.bank.replenish(@game_bank.withdraw(half_bank))
    puts "Stand-off!"
  end

  def open_cards
    if @dealer.get_cards_value == @player.get_cards_value && @dealer.get_cards_value > 0
      stand_off
    elsif @dealer.get_cards_value < @player.get_cards_value
      player_winner
    elsif @dealer.get_cards_value > @player.get_cards_value
      dealer_winner
    else
      puts "it's not time yet for openning cards"
    end
    game_ended = true
  end


  #def add_cards_to(player_type, quantity)
    #quantity.times { player_type.add_card(@deck.give_card) }
  #end

  def restart!
    @game_bank.reset
    @player.bank.reset
    @dealer.bank.reset
    show_menu
  end

  def check_game_ended
    if game_ended?
      puts 'The game is over!'
      puts 'Would you like to play again? (Y/N)'
      choice = gets.chomp.downcase
      if choice == 'y'
        restart!
      else
        puts 'GAME OVER'
        exit(0)
      end
    end
  end
end
