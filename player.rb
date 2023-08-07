# frozen_string_literal: true

require_relative 'bank'
require_relative 'constants'

class Player
  include Constants

  attr_reader :cards, :bank
  attr_accessor :name

  def initialize(initial_amount = INITIAL_PLAYER_BANK_AMOUNT)
    @cards = []
    @bank  = Bank.new(initial_amount)
    @name  = ''
  end

  def add_card(card)
    @cards << card
  end

  def reset_cards
    @cards.clear
  end

  def has_an_ace?
    @cards.each { |card| card.rank  == "A" }
  end

  
  def count_cards_value
    @points = 0
    @cards.each do |card|
      @points += VALUES[card.rank]
    end
    @points += 10 if self.has_an_ace? && @points <= 11
    @points
  end

  def show_cards
    @cards.map { |card| "#{card.rank}#{card.suit}" }.join('|')
  end

  def show_cards_as_hidden
    @cards.map { |card| '*' }.join('')
  end
end
