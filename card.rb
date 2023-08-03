# frozen_string_literal: true

require_relative 'constants'

class Card
  include Constants
  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end
end
