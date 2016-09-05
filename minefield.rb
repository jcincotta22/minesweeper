require_relative "cell"

class Minefield
  attr_reader :row_count, :column_count, :grid

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @mine_count = mine_count
    @mines_revealed = false
    @cleared_cell_count = 0

    build_minefield
    place_mines
  end

  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    @grid[row][col].revealed?
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
    if !@grid[row][col].revealed?
      @grid[row][col].reveal!
      if !contains_mine?(row, col)
        @cleared_cell_count += 1
      end
      if @grid[row][col].adj_mines == 0
        if contains_point?(row-1, col)
            clear(row-1, col)
        end
        if contains_point?(row+1, col)
            clear(row+1, col)
        end
        if contains_point?(row, col-1)
            clear(row, col-1)
        end
        if contains_point?(row, col+1)
            clear(row, col+1)
        end
      end
    end
  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    @mines_revealed
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    @cleared_cell_count == ((@row_count * @column_count) - @mine_count) && @mines_revealed == false
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    @grid[row][col].adj_mines
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
    if @grid[row][col].mine == true
      @mines_revealed = true
      return true
    else
      return false
    end
  end

  private

  # Create a data structure within an instance variable that will represent
  # the minefield.
  def build_minefield
    @grid = Array.new(@row_count) {Array.new(@column_count) {Cell.new}}
  end

  # Distribute mines amongst the individual minefield cells
  def place_mines
    mines_counter = @mine_count
    until mines_counter == 0
      y_coord = rand(@row_count)
      x_coord = rand(@column_count)
      if !@grid[y_coord][x_coord].contains_mine?
        @grid[y_coord][x_coord].mine = true
        mines_counter -= 1
        increment_adjacent_mines(y_coord, x_coord)
      end
    end
  end

  def contains_point?(y_coord, x_coord)
    x_coord >= 0 && x_coord < (@column_count) && y_coord >= 0 && y_coord < (@row_count)
  end

  def increment_adjacent_mines(y_coord, x_coord)
    if contains_point?(y_coord-1, x_coord-1)
      adjust_mine_at_coord(y_coord-1, x_coord-1)
    end
    if contains_point?(y_coord-1, x_coord)
      adjust_mine_at_coord(y_coord-1, x_coord)
    end
    if contains_point?(y_coord-1, x_coord+1)
      adjust_mine_at_coord(y_coord-1, x_coord+1)
    end
    if contains_point?(y_coord, x_coord-1)
      adjust_mine_at_coord(y_coord, x_coord-1)
    end
    if contains_point?(y_coord, x_coord+1)
      adjust_mine_at_coord(y_coord, x_coord+1)
    end
    if contains_point?(y_coord+1, x_coord-1)
      adjust_mine_at_coord(y_coord+1, x_coord -1)
    end
    if contains_point?(y_coord+1, x_coord)
      adjust_mine_at_coord(y_coord+1, x_coord)
    end
    if contains_point?(y_coord+1, x_coord+1)
      adjust_mine_at_coord(y_coord+1, x_coord+1)
    end
  end

  def adjust_mine_at_coord(y, x)
    @grid[y][x].adj_mines += 1
  end
end
