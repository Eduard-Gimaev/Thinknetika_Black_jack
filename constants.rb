module Constants
  SUITS = Set['C', 'S', 'H', 'D']
  RANKS = Set['A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K']
  VALUES = {
  'A' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9,
  'T' => 10, 'J' => 10, 'Q' => 10, 'K' => 10
  }
INITIAL_PLAYER_BANK_AMOUNT = 100

MAX_ALLOWED_CARDS = 3

MAX_SCORE = 21
end