class User

  attr_reader :name, :cards, :bank

  def initialize(name)
    @name = name
    @cards = []
    @bank = 100
  end

  def add_card(new_card)
    @cards << new_card
  end

  def open_cards
    puts "Players: #{@cards}"
  end

end