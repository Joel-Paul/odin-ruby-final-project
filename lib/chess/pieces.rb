
class Piece
  attr_reader :color

  def initialize(color)
    @color = color
    @forward = color == :white ? -1 : 1
    @moved = false
  end

  def icon
    raise NotImplementedError, 'This method must be overriden in a subclass'
  end
  
  def get_moves(board, position)
    raise NotImplementedError, 'This method must be overriden in a subclass'
  end

  def orthogonal_moves(board, position, range=7)
    moves = []

    up = [-1, 0]
    down = [1, 0]
    left = [0, -1]
    right = [0, 1]
    for dir in [up, down, left, right]

      for i in 1..range
        target = [position[0] + dir[0] * i, position[1] + dir[1] * i]
        break unless inside_bounds?(target)

        piece = get_piece(board, target)
        if piece.nil?
          moves.append target
        elsif piece.color != @color
          moves.append target
          break
        else
          break
        end
      end

    end
    moves
  end
  
  def diagonal_moves(board, position, range=7)
    moves = []

    up_left = [-1, -1]
    up_right = [-1, 1]
    down_left = [1, -1]
    down_right = [1, 1]
    for dir in [up_left, up_right, down_left, down_right]

      for i in 1..range
        target = [position[0] + dir[0] * i, position[1] + dir[1] * i]
        break unless inside_bounds?(target)

        piece = get_piece(board, target)
        if piece.nil?
          moves.append target
        elsif piece.color != @color
          moves.append target
          break
        else
          break
        end
      end

    end
    moves
  end

  def valid_move?(board, from, to)
    moves = get_moves(board, from)
    moves.include?(to)
  end

  def move(board, from, to)
    target = board[to[0]][to[1]]
    board[from[0]][from[1]] = nil
    board[to[0]][to[1]] = self
    @moved = true
    target
  end

  def get_piece(board, position)
    row = board[position[0]]
    return if not row
    piece = row[position[1]]
    return piece if piece
  end

  def get_checking(board, position)
    for move in get_moves(board, position)
      piece = get_piece(board, move)
      return move if piece.is_a?(King) and piece.color != @color
    end
    false
  end

  def inside_bounds?(position)
    position[0].between?(0, 7) and position[1].between?(0, 7)
  end
end


class Pawn < Piece
  attr_accessor :en_passant

  def initialize(color)
    super(color)
    @en_passant = false
  end

  def icon
    @color == :white ? '♙' : '♟'
  end

  def get_moves(board, position)
    moves = []

    # Forward movement
    front = [position[0] + @forward, position[1]]
    unless get_piece(board, front)
      moves.append(front)
      target = [front[0] + @forward, front[1]]
      moves.append(target) unless @moved or get_piece(board, target)
    end

    # Take diagonally
    diag_left = [position[0] + @forward, position[1] - 1]
    diag_right = [position[0] + @forward, position[1] + 1]
    for side in [diag_left, diag_right]
      piece = get_piece(board, side)
      moves.append(side) if piece and @color != piece.color
    end

    # En Passant
    left = [position[0], position[1] - 1]
    right = [position[0], position[1] + 1]
    for side in [left, right]
      piece = get_piece(board, side)
      if piece.is_a?(Pawn) and piece.en_passant
        target = [side[0] + @forward, side[1]]
        moves.append(target) unless get_piece(board, target)
      end
    end

    moves
  end

  def move(board, from, to)
    target = super

    # Set En Passant
    if to[0] - from[0] == 2 * @forward
      @en_passant = true
    end

    # Check En Passant Capture
    if to[1] - from[1] != 0
      pos = [from[0], to[1]]
      piece = get_piece(board, pos)
      if piece.is_a?(Pawn) and piece.en_passant
        target = board[pos[0]][pos[1]]
        board[pos[0]][pos[1]] = nil
      end
    end

    target
  end
end


class Rook < Piece
  def icon
    @color == :white ? '♖' : '♜'
  end

  def get_moves(board, position)
    orthogonal_moves(board, position)
  end
end


class Knight < Piece
  def icon
    @color == :white ? '♘' : '♞'
  end

  def get_moves(board, position)
    moves = []

    move_1 = [1, 2]
    move_2 = [2, 1]

    for move in [move_1, move_2]
      for y in [-1, 1]
        for x in [-1, 1]

          target = [position[0] + move[0] * y, position[1] + move[1] * x]
          next unless inside_bounds?(target)
          
          piece = get_piece(board, target)
          if piece.nil? or piece.color != @color
            moves.append target
          end

        end
      end
    end

    moves
  end
end


class Bishop < Piece
  def icon
    @color == :white ? '♗' : '♝'
  end

  def get_moves(board, position)
    diagonal_moves(board, position)
  end
end


class Queen < Piece
  def icon
    @color == :white ? '♕' : '♛'
  end

  def get_moves(board, position)
    orthogonal_moves(board, position) + diagonal_moves(board, position)
  end
end

class King < Piece
  def icon
    @color == :white ? '♔' : '♚'
  end

  def get_moves(board, position)
    orthogonal_moves(board, position, range=1) + diagonal_moves(board, position, range=1)
  end
end