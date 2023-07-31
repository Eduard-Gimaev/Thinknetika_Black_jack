require_relative 'dealer'
require_relative 'user'

class Game
  COMMAND = {
    1 => 'new_game', 2 => 'exit'
  }.freeze

  attr_reader :bank, :deck_of_cards, :users

  def initialize
    @bank = 0
    @deck_of_cards = 
    [
      'Q+','Q<3','Q^','Q<>',
      'К+','К<3','К^','К<>',
      'T+','T<3','T^','T<>'
    ]
    @user = 0
    @dealer = 0
  end

  def start
    loop do
      show_menu
      command = gets.chomp.to_i
      run(command)
    end
  end

  #private
  def show_menu
    menu_items = ['new_game', 'exit']
    menu_items.each.with_index(1) { |item, index| puts "#{index}. #{item}" }
  end

  def run(command)
    #@run = COMMAND[command] || 'there is no such command, try again'
   case command
   when 1 then new_game
   when 2 then exit
   else
    puts "there is no such command, try again"
   end
  end
  
  def new_game
    puts 'Enter your name:'
    name = gets.chomp.to_s.capitalize
    @user = User.new(name)
    @dealer = Dealer.new
    puts" "
  rescue StandardError => e
    puts e
  end

  #Complementary_methods
=begin
  def get_card
    new_card = @deck_of_cards.shuffle.first
    @deck_of_cards.delete(new_card)
  end

  def dealer_get_card
    new_card = @deck_of_cards.shuffle.first
    @dealer.add_card(new_card)
    @deck_of_cards.delete(new_card)
  end
=end
  
end


