
class Game
  COMMAND = {
    1 => 'new_game', 2 => 'exit'
  }.freeze

  def initialize
    @bank = 0
    @deck_of_cards = []
  end

  def start
    loop do
      show_menu
      command = gets.chomp.to_i
      run(command)
    end
  end

  private
  def show_menu
    menu_items = [
      'new_game', 'exit'
    ]
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
end


