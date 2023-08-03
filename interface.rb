# frozen_string_literal: true

require_relative 'game_logic'

class Interface
  def initialize
    @game = Game.new
  end

  def start_game
    @game.ask_user_name
    @game.ask_action
  end
end
