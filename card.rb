require_relative 'constants'

class Card
  include Constants
  attr_reader :suit, :rank

  def initialize(suit, rank)
      @suit = suit
      @rank = rank
  end

  def to_s
    @rank + @suit 
  end
end
