class Bank
  attr_reader :amount

  def initialize(initial_amount = 0)
    @initial_amount = initial_amount
    @amount = initial_amount
  end

  def replenish(amount)
    @amount += amount
    amount
  end

  def withdraw(amount)
    @amount -= amount
    amount
  end

  def reset
    @amount = @initial_amount
  end
end
