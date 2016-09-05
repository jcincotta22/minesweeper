# A class that represents an individual cell in the minefield.
class Cell
  attr_reader :revealed
  attr_accessor :mine, :adj_mines
  def initialize
    @mine = false
    @revealed = false
    @adj_mines = 0
  end

  def place_mine
    @mine = true
  end

  def contains_mine?
    @mine
  end

  def reveal!
    @revealed = true
  end

  def revealed?
    @revealed
  end
end
