
class Piece
  attr_reader :color

  def initialize(color)
    @color = color
    @forward = color == :white ? 1 : -1
    @moved = false
  end

  def icon
    raise NotImplementedError, 'This method must be overriden in a subclass'
  end
  
  def get_moves(board, position)
    raise NotImplementedError, 'This method must be overriden in a subclass'
  end

  def get_piece(board, position)
    row = board[position[0]]
    return if not row
    piece = row[position[1]]
    return piece if piece
  end
end

class Pawn < Piece
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
      if side.is_a?(Pawn) and side.en_passant
        target = [side[0] + @forward, side[1]]
        moves.append(target) unless get_piece(board, target)
      end
    end

    moves
  end
end

class Rook < Piece
  def icon
    @color == :white ? '♖' : '♜'
  end
end

class Knight < Piece
  def icon
    @color == :white ? '♘' : '♞'
  end
end

class Bishop < Piece
  def icon
    @color == :white ? '♗' : '♝'
  end
end

class Queen < Piece
  def icon
    @color == :white ? '♕' : '♛'
  end
end

class King < Piece
  def icon
    @color == :white ? '♔' : '♚'
  end
end