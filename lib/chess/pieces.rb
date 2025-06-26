
class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def icon
    raise NotImplementedError, 'This method must be overriden in a subclass'
  end
end

class Pawn < Piece
  def icon
    @color == :white ? '♙' : '♟'
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