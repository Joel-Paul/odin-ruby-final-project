require_relative 'chess/pieces'

class Chess
  def initialize
    @board = Array.new(8) { Array.new(8) }

    setup_board
  end

  def setup_board
    8.times do |i|
      @board[1][i] = Pawn.new :black
      @board[6][i] = Pawn.new :white
    end

    @board[0][0] = Rook.new :black
    @board[0][7] = Rook.new :black
    @board[7][0] = Rook.new :white
    @board[7][7] = Rook.new :white

    @board[0][1] = Knight.new :black
    @board[0][6] = Knight.new :black
    @board[7][1] = Knight.new :white
    @board[7][6] = Knight.new :white

    @board[0][2] = Bishop.new :black
    @board[0][5] = Bishop.new :black
    @board[7][2] = Bishop.new :white
    @board[7][5] = Bishop.new :white

    @board[0][3] = Queen.new :black
    @board[7][3] = Queen.new :white

    @board[0][4] = King.new :black
    @board[7][4] = King.new :white
  end

  def display_board
    files = '  a b c d e f g h'
    display = files
    @board.each_with_index do |row, i|
      rank = 8 - i
      pieces = (row.map { |piece| piece&.icon || '.' }).join(' ')
      display += "\n#{rank} #{pieces} #{rank}"
    end
    display += "\n#{files}"
    puts display
  end
end
