# frozen_string_literal: true

require_relative 'card'
require_relative 'constants'

class Deck
  include Constants
  def initialize
    @deck = create_deck
    shuffle
  end

  def create_deck
    SUITS.map { |suit| RANKS.map { |rank| Card.new(suit, rank) } }.flatten
  end

  def shuffle
    @deck.shuffle!
  end

  def give_card
    @deck.pop
  end

  def reset
    @deck.clear
  end

  def show
    @deck.each(&:rank)
  end
end
