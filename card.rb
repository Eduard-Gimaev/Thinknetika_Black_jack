require 'set'
require_relative 'constants'

class Card
  include Constants

  attr_accessor :suit, :rank

  def initialize(suit, rank)
    if SUITS.include?(suit) and RANKS.include?(rank)
      @suit = suit
      @rank = rank
    else
      puts "Invalid card: ", suit, rank
    end
  end

  def to_s
    @suit + @rank
  end

  def self.suits
    SUITS
  end

  def self.ranks
    RANKS
  end

  def self.values
    VALUES
  end
end
