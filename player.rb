require_relative 'bank'
require_relative 'constants'

class Player
  include Constants

  attr_reader :cards, :bank
  attr_accessor :name

  def initialize(initial_amount=INITIAL_PLAYER_BANK_AMOUNT)
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

  def count_aces
    @cards.count {|c| c.rank == "A"}
  end

  def get_cards_value
    total_value = 0
    aces_quantity = count_aces
    if aces_quantity == 0
      @cards.each do |card|
      total_value += VALUES[card.rank]
      end
    else
      aces_quantity.times do
        total_value += 10 if total_value + 10 <= 21
      end
    end
    total_value
  end

  def show_cards
    @cards.map { |card| card }.join('|')
  end

  def show_cards_as_hidden
    @cards.map { |card| card = '*'}.join('')
  end
end
