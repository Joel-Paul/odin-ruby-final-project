require_relative 'chess/pieces'

class Chess
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def new_game
    setup_board
    play
  end

  def play(turn=:white)
    loop do
      puts "#{turn.capitalize}'s turn. Enter your move (e.g., e2 e4) or a square to show moves (e.g., e2):"
      display_board

      from, to = player_input(turn)

      target = @board[to[0]][to[1]]
      if target
        puts "#{turn.capitalize} captures #{target.class}!"
      end

      piece = @board[from[0]][from[1]]
      @board[to[0]][to[1]] = piece
      @board[from[0]][from[1]] = nil
      piece.moved = true

      turn = turn == :white ? :black : :white
    end
  end

  def player_input(turn)
    loop do
      input = gets.chomp.downcase
      next if show_moves(input)
      move = verify_move(turn, input)
      return move if move

      puts 'Invalid move!'
    end
  end

  def translate_coords(file, rank)
    row = 8 - rank.to_i
    col = file.ord - 'a'.ord
    [row, col]
  end

  def show_moves(input)
    return unless input.match?(/^[a-h][1-8]$/)
    pos = translate_coords(input[0], input[1])
    piece = @board[pos[0]][pos[1]]
    return unless piece
    moves = piece.get_moves(@board, pos)
    display_board moves
    moves
  end

  def verify_move(turn, input)
    return unless input.match?(/^[a-h][1-8] [a-h][1-8]$/)

    # Convert from file_rank to [row, column]
    from = translate_coords(input[0], input[1])
    to = translate_coords(input[3], input[4])
    
    return unless from[0].between?(0, 7) and from[1].between?(0, 7)
    return unless to[0].between?(0, 7) and to[1].between?(0, 7)
    
    # Check if the piece is valid and the right color
    piece = @board[from[0]][from[1]]
    return unless piece and piece.color == turn

    # Check the target is empty or an opponent piece
    target = @board[to[0]][to[1]]
    return if target and target.color == turn

    return unless piece.valid_move?(@board, from, to)

    [from, to]
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

  def display_board(moves = [])
    files = '  a b c d e f g h'
    display = files
    @board.each_with_index do |row, i|
      rank = 8 - i
      pieces = (row.map { |piece| piece&.icon || '.' }).join(' ')
      pieces = highlight_moves(moves, " #{pieces} ", i)
      display += "\n#{rank}#{pieces}#{rank}"
    end
    display += "\n#{files}"
    puts display
  end

  def highlight_moves(moves, pieces, i)
    8.times do |j|
      pos = [i, j]
      left = [pos[0], pos[1] - 1]
      right = [pos[0], pos[1] + 1]
      if moves.include?(pos)
        l_sym = moves.include?(left) ? '|' : '['
        r_sym = moves.include?(right) ? '|' : ']'
        pieces[j * 2] = l_sym
        pieces[j * 2 + 2] = r_sym
      end
    end
    pieces
  end
end
