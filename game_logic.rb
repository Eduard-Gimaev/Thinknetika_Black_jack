# frozen_string_literal: true

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
    while @player.name.empty?
      print 'Enter your name: '
      @player.name = gets.chomp.capitalize
    end
  end

  def ask_action
    loop do
      show_menu
      choice = gets.chomp.downcase
      case choice
      when '0' then ask_action
      when '1' then deal_cards
      when '2' then take_card
      when '3' then stand
      when '4' then open_cards
      when 'exit' then exit
      else
        puts ' = there is no such command, try again = '
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
    if @player.cards.empty? && @dealer.cards.empty?
      2.times { @player.cards << @deck.give_card }
      2.times { @dealer.cards << @deck.give_card }
      first_bet
      show_banks
      show_cards_and_values_hide
      puts '=' * 30
    else
      puts 'The game in the process....'
      ask_action
    end
  end

  def show_banks
    puts "#{@player.name} bank: #{@player.bank.amount}"
    puts "Dealer's bank: #{@dealer.bank.amount}"
    puts "Game's bank: #{@game_bank.amount}"
    puts '=' * 30
  end

  def first_bet
    @player.bank.withdraw(10)
    @dealer.bank.withdraw(10)
    @game_bank.replenish(20)
  end

  def show_cards_and_values
    puts "#{@player.name}'s cards #{@player.show_cards} - (#{@player.count_cards_value})"
    puts "Dealer's card: #{@dealer.show_cards} - (#{@dealer.count_cards_value})"
  end

  def show_cards_and_values_hide
    puts "#{@player.name}'s cards #{@player.show_cards} - (#{@player.count_cards_value})"
    puts "Dealer's card: #{@dealer.show_cards_as_hidden} - (**)"
  end

  def take_card
    if @player.cards.count < MAX_ALLOWED_CARDS && @player.count_cards_value <= MAX_SCORE && @player.cards.count > 1
      @player.add_card(@deck.give_card)
      show_cards_and_values_hide
      if @player.count_cards_value > 21
        puts '  == YOU ARE BURNT OUT! ==  '
        dealer_winner
      elsif @player.cards.count >= MAX_ALLOWED_CARDS
        stand # the move switched to Dealer
      end
    elsif @player.count_cards_value < 1
      puts ' = Deal cards first, you cannot take a card now = '
      puts '=' * 30
    else
      puts ' = Sorry, you cannot take a card = '
      puts '=' * 30
    end
  end

  def stand
    puts "Dealer's move >>\n\n"
    if @dealer.count_cards_value < 17 && @dealer.cards.count < MAX_ALLOWED_CARDS
      @dealer.add_card(@deck.give_card)
      show_cards_and_values_hide
      open_cards if @dealer.cards.count == MAX_ALLOWED_CARDS && @player.cards.count == MAX_ALLOWED_CARDS
    elsif @dealer.count_cards_value > 21
      player_winner
    else
      open_cards
    end
  end

  def dealer_winner
    puts '=' * 30
    puts '  == DEALER IS THE WINNER! =='
    puts '=' * 30
    show_cards_and_values
    puts '=' * 30
    @dealer.bank.replenish(@game_bank.withdraw(@game_bank.amount))
    show_banks
    check_game_ended(true)
  end

  def player_winner
    puts '=' * 30
    puts '  == PLAYER IS THE WINNER! =='
    puts '=' * 30
    show_cards_and_values
    puts '=' * 30
    @player.bank.replenish(@game_bank.withdraw(@game_bank.amount))
    show_banks
    check_game_ended(true)
  end

  def stand_off
    puts ' == STAND-OFF! == '
    puts '=' * 30
    show_banks
    show_cards_and_values
    half_bank = @game_bank.amount / 2
    @player.bank.replenish(@game_bank.withdraw(half_bank))
    @dealer.bank.replenish(@game_bank.withdraw(half_bank))
    @player.reset_cards
    @dealer.reset_cards
  end

  def open_cards
    if @dealer.count_cards_value == @player.count_cards_value && @dealer.count_cards_value.positive?
      stand_off
    elsif @dealer.count_cards_value < @player.count_cards_value
      player_winner
    elsif @dealer.count_cards_value > @player.count_cards_value
      dealer_winner
    else
      puts " = it's not time yet for openning cards = "
    end
    check_game_ended(true)
  end

  def game_ended?(value)
    @game_ended = value
    @game_ended
  end

  def restart!
    @game_bank.reset
    @player.reset_cards
    @dealer.reset_cards
    @deck = Deck.new
    puts '=' * 30
    puts "Let's start a new game..."
    puts '=' * 30
    ask_action
  end

  def game_over
    puts '  == GAME OVER ==  '
    puts 'Would you like to play again? (Y/N)'
    loop do
      choice = gets.chomp.downcase
      case choice
      when 'y' then restart!
      when 'n' then exit(0)
      else
        puts ' = there is no such command, try again = '
      end
      # rescue StandardError => e
      # puts "::ERROR:: #{e.message}"
    end
  end

  def check_game_ended(value)
    if game_ended?(value) == true && @player.bank.amount.positive? && @dealer.bank.amount.positive?
      game_over
    elsif @player.bank.amount.zero?
      puts '  == PLAYER IS BANKRUPT!!! ==  '
      puts '=' * 30
      puts '  == GAME OVER ==  '
      exit(0)
    elsif @dealer.bank.amount.zero?
      puts '  == DEALER IS BANKRUPT!!! ==  '
      puts '=' * 30
      puts '  == GAME OVER ==  '
      exit(0)
    else
      puts '  == The game has not finished yet == '
      puts '=' * 30
    end
  end
end
