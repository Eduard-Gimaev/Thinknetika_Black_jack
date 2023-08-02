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
      show_cards_and_values_hide
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
    puts "=" * 30
  end
  def first_bet
    @dealer.bank.withdraw(5)
    @dealer.bank.withdraw(5)
    @game_bank.replenish(10)
  end

  def show_cards_and_values
    puts "#{@player.name}'s cards #{@player.show_cards} - (#{@player.get_cards_value})"
    puts "Dealer's card: #{@dealer.show_cards} - (#{@dealer.get_cards_value})"
    puts
  end

  def show_cards_and_values_hide
    puts "#{@player.name}'s cards #{@player.show_cards} - (#{@player.get_cards_value})"
    puts "Dealer's card: #{@dealer.show_cards_as_hidden} - (**)"
    puts
  end

  def take_card
    if @player.cards.count < MAX_ALLOWED_CARDS && @player.get_cards_value <= MAX_SCORE
      @player.add_card(@deck.give_card)
      show_cards_and_values_hide
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
        show_cards_and_values_hide
        open_cards if @dealer.cards.count == MAX_ALLOWED_CARDS && @player.cards.count == MAX_ALLOWED_CARDS
      elsif @dealer.get_cards_value > 21
        player_winner 
      else
        open_cards
      end
  end

  def dealer_winner
    @player.reset_cards
    @dealer.reset_cards
    @dealer.bank.replenish(@game_bank.withdraw(@game_bank.amount))
    puts "Dealer won the game!"
    puts "=" * 30
    show_banks
    show_cards_and_values
    puts "=" * 3
    check_game_ended(true)
  end

  def player_winner
    @player.reset_cards
    @dealer.reset_cards
    @player.bank.replenish(@game_bank.withdraw(@game_bank.amount))
    puts "Player won the game!"
    puts "=" * 30
    show_banks
    show_cards_and_values
    puts "=" * 30
    check_game_ended(true)
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
    check_game_ended(true)
  end

  def game_ended?(value)
    @game_ended = value
    @game_ended
  end

  def restart!
    @game_bank.reset
    @player.bank.reset
    @dealer.bank.reset
    show_menu
  end

  def check_game_ended(value)
    if game_ended?(value)
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
