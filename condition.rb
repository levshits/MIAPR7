class Condition
  attr_accessor :items_sets,
                :symbols
  def initialize(items, symbols)
    @items_sets = items
    @symbols = symbols
  end
  def == other
    return self.items_sets == other.items_sets && self.symbols == other.symbols
  end
end