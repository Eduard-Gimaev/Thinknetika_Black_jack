require_relative 'card'

class Deck
  def initialize
    @deck = []
    Card.suits.each do |suit|
      Card.ranks.each do |rank|
        @deck << Card.new(suit, rank)
      end
    end
  end

  def shuffle
    @deck.shuffle!
  end

  def deal_card
    # deal a card object from the deck
    @deck.pop
  end

end
