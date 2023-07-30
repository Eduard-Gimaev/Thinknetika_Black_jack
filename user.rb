class User

  def initialize(name)
    @name = name
    @cards = []
    @bank = 100
  end

  def skip

  end

  def add_card
      new_card = deck_of_cards.shuffle.first
      @card << new_card
  end

  def open_cards

  end
end