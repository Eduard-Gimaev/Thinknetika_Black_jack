require_relative 'bank'
require_relative 'constants'

class Player
  include Constants

  attr_reader :cards, :bank
  attr_accessor :name

  def initialize(initial_amount=INITIAL_PLAYER_BANK_AMOUNT)
    @cards = []
    @bank  = Bank.new(initial_amount)
    @name  = nil
  end

  def add_card(card)
    @cards << card
  end

  def reset_cards
    @cards.clear
  end

  def get_cards_value
    # count the aces as 1 if there is an ace in the hand, then add 10 to the value of the hand if this does not help calculate the value of the hand
    total_value = 0
    @cards.each do |card|
      total_value += VALUES[card.rank]
    end

    aces_quantity = count_aces
    if aces_quantity == 0
      return total_value
    else
      aces_quantity.times do
        if total_value + 10 <= 21
          total_value += 10
        end
      end
    end
    total_value
  end

  def count_aces
    @cards.count {|c| c.rank == "A"}
  end


  def show_cards
    @cards.map { |card| card }.join('|')
  end

  def show_cards_as_hidden
    @cards.map { |card| card = '*'}.join('')
  end
end
