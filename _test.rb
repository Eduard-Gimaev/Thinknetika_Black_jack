require_relative '_interface'
require_relative 'dealer'
require_relative 'user'

#new_game
new_game = Game.new
@bank = 0
@deck_of_cards = {
  '2+': 2 ,'2<3': 2, '2^': 2, 'Q<>': 2,
  '3+': 3 ,'3<3': 3, '3^': 3, '3<>': 3,
  '4+': 4 ,'4<3': 4, '4^': 4, '4<>': 4,
  '5+': 5 ,'5<3': 5, '5^': 5, '5<>': 5,
  '6+': 6 ,'6<3': 6, '6^': 6, '6<>': 6,
  '7+': 7 ,'7<3': 7, '7^': 7, '7<>': 7,
  '8+': 8 ,'8<3': 8, '8^': 8, '8<>': 8,
  '9+': 9 ,'9<3': 9, '9^': 9, '9<>': 9,
  '10+': 10 ,'10<3': 10, '10^': 10, '10<>': 10,
  'Q+': 10 ,'Q<3': 10, 'Q^': 10, 'Q<>': 10,
  'K+': 10 ,'K<3': 10, 'K^': 10, 'K<>': 10,
  'T+': 10 ,'T<3': 10, 'T^': 10, 'T<>': 10
}

@user = 0
@dealer = 0
@card = 0

#start_game
@user = User.new("Ed")
@dealer = Dealer.new

@user.add_card(1)
@user.add_card(2)
@dealer.add_card(3)
@dealer.add_card(4)
@user.open_cards
@dealer.open_cards

def get_card
  @card = @deck_of_cards.to_a.sample(1).to_h
  @user.add_card(@card)
  @deck_of_cards.delete(@card.key)
end
