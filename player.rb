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

  def to_s
    "has cards: #{@cards.join( ',')}"
  end

  def add_card(card)
    @cards << card
  end

  def reset_cards
    @cards.clear
  end

  def get_cards_value
    # count aces as 1, if the hand has an ace, then add 10 to hand value if it doesn't bust compute the value of the hand
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

  def show_cards_as_hidden
    @cards.map { |el| el = '*'}.join(',')
  end
end
