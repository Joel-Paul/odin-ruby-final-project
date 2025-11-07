require_relative 'chess/pieces'

class Chess
  def initialize
    @board = Array.new(8) { Array.new(8) }
    @turn = :white
    @prev_move = []
    @checking = []
    @checked_player = :none
  end

  def new_game
    setup_board
    play
  end

  def play_turn
    reset_en_passant

    prev_copy = @prev_move
    @prev_move = player_input
    return :exit if @prev_move.nil?  # exit game
    from, to = @prev_move

    piece = @board[from[0]][from[1]]
    target, pos = piece.move(@board, from, to)

    @checked_player = get_checked_player
    if @checked_player == @turn
      # Undo move if it results in current player landing in check
      @board[from[0]][from[1]] = piece
      @board[to[0]][to[0]] = nil
      @board[pos[0]][pos[1]] = target
      @prev_move = prev_copy
      return :undo
    end
    @turn = @turn == :white ? :black : :white
    target
  end

  def play
    loop do
      turn = @turn
      puts "#{turn.capitalize}'s turn. Enter your move (e.g., e2 e4) or a square to show moves (e.g., e2):"
      display_board

      target = nil
      loop do
        target = play_turn
        return if target == :exit
        if target == :undo
          puts "This move will put you in check, try again..."
        else
          break
        end
      end

      puts "#{turn.capitalize} captures #{target.class}!" if target
      puts "#{@checked_player.capitalize} in check!" unless @checked_player == :none
    end
  end

  def player_input
    loop do
      input = gets.chomp.downcase
      return nil if input == 'quit'
      next if show_moves(input)
      move = verify_move(input)
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
    display_board(moves)
    moves
  end

  def verify_move(input)
    return unless input.match?(/^[a-h][1-8] [a-h][1-8]$/)

    # Convert from file_rank to [row, column]
    from = translate_coords(input[0], input[1])
    to = translate_coords(input[3], input[4])
    
    return unless from[0].between?(0, 7) and from[1].between?(0, 7)
    return unless to[0].between?(0, 7) and to[1].between?(0, 7)
    
    # Check if the piece is valid and the right color
    piece = @board[from[0]][from[1]]
    return unless piece and piece.color == @turn

    # Check the target is empty or an opponent piece
    target = @board[to[0]][to[1]]
    return if target and target.color == @turn

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

  def display_board(moves=[])
    @checking = get_checking
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
      l_inc = moves.include?(left) or @checking.include?(left) or @prev_move.include?(left)
      r_inc = moves.include?(right) or @checking.include?(right) or @prev_move.include?(right)
      l_sym = nil
      r_sym = nil
      if moves.include?(pos)
        l_sym = l_inc ? '|' : '['
        r_sym = r_inc ? '|' : ']'
      elsif @checking.include?(pos)
        l_sym = l_inc ? '|' : '{'
        r_sym = r_inc ? '|' : '}'
      elsif @prev_move.include?(pos)
        l_sym = l_inc ? '|' : '('
        r_sym = r_inc ? '|' : ')'
      end
      if l_sym and r_sym
        pieces[j * 2] = l_sym
        pieces[j * 2 + 2] = r_sym
      end
    end
    pieces
  end

  def reset_en_passant
    @board.each do |row|
      row.each do |piece|
        if piece.is_a?(Pawn) and piece.color == @turn
          piece.en_passant = false
        end
      end
    end
  end

  def get_checked_player
    @board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        position = [i, j]
        if piece
          king_pos = piece.get_checking(@board, position)
          next if king_pos.nil?
          king = @board[king_pos[0]][king_pos[1]]
          return king.color
        end
      end
    end
    :none
  end

  def get_checking
    checking = []
    @board.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        position = [i, j]
        if piece
          king = piece.get_checking(@board, position)
          checking.append(position, king) if king
        end
      end
    end
    checking
  end
end
