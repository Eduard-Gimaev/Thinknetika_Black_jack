class Dealer 
    attr_reader :name, :cards, :bank

    def initialize
        @name = "Dealer"
        @cards = []
        @bank = 100
    end

    def add_card(new_card)
        @cards << new_card
    end
    def open_cards
        puts "Dealer: #{@cards}"
    end

end