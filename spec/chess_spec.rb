require_relative '../lib/chess'

describe Chess do
  subject(:new_game) { described_class.new }

  let(:starting_board) do
    "  a b c d e f g h\n" + \
    "8 ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜ 8\n" + \
    "7 ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟ 7\n" + \
    "6 . . . . . . . . 6\n" + \
    "5 . . . . . . . . 5\n" + \
    "4 . . . . . . . . 4\n" + \
    "3 . . . . . . . . 3\n" + \
    "2 ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙ 2\n" + \
    "1 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ 1\n" + \
    "  a b c d e f g h"
  end

  let(:intro_white) { "White's turn. Enter your move (e.g., e2 e4) or a square to show moves (e.g., e2):" }
  let(:intro_black) { "Black's turn. Enter your move (e.g., e2 e4) or a square to show moves (e.g., e2):" }

  let(:quit) { 'quit' }

  describe '#display_board' do
    it 'displays the board in a new game state' do
      expected = starting_board
      expect(new_game).to receive(:puts).with(expected)
      new_game.setup_board
      new_game.display_board
    end

    it 'displays moved pawn' do
      expected = \
        "  a b c d e f g h\n" + \
        "8 ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜ 8\n" + \
        "7 ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟ 7\n" + \
        "6 . . . . . . . . 6\n" + \
        "5 . . . . . . . . 5\n" + \
        "4 . . . . . . . . 4\n" + \
        "3(♙). . . . . . . 3\n" + \
        "2(.)♙ ♙ ♙ ♙ ♙ ♙ ♙ 2\n" + \
        "1 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ 1\n" + \
        "  a b c d e f g h"
      move = 'a2 a3'

      allow(new_game).to receive(:gets).and_return(move, quit)
      expect(new_game).to receive(:puts).with(expected)

      new_game.setup_board
      new_game.play_turn
      new_game.display_board
    end

    it 'displays En Passant pawn' do
       expected = \
        "  a b c d e f g h\n" + \
        "8 ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜ 8\n" + \
        "7 . . ♟ ♟ ♟ ♟ ♟ ♟ 7\n" + \
        "6 ♟(♙). . . . . . 6\n" + \
        "5(.). . . . . . . 5\n" + \
        "4 . . . . . . . . 4\n" + \
        "3 . . . . . . . . 3\n" + \
        "2 . ♙ ♙ ♙ ♙ ♙ ♙ ♙ 2\n" + \
        "1 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ 1\n" + \
        "  a b c d e f g h"
      moves = ['a2 a4', 'a7 a6', 'a4 a5', 'b7 b5', 'a5 b6']

      allow(new_game).to receive(:gets).and_return(*moves, quit)
      expect(new_game).to receive(:puts).with(expected)

      new_game.setup_board
      moves.length.times do
        new_game.play_turn
      end
      new_game.display_board
    end

    it 'display legal moves only' do
       expected = \
        "  a b c d e f g h\n" + \
        "8 ♜ ♞ ♝(.)♚ ♝ ♞ ♜ 8\n" + \
        "7 ♟ ♟ . ♟ ♟ ♟ ♟ ♟ 7\n" + \
        "6 . . . . . . . . 6\n" + \
        "5{♛}. ♙ . . . . . 5\n" + \
        "4 . . . . . . . . 4\n" + \
        "3 . . . . . . . . 3\n" + \
        "2 ♙ ♙ ♙[.]♙ ♙ ♙ ♙ 2\n" + \
        "1 ♖ ♘ ♗ ♕{♔}♗ ♘ ♖ 1\n" + \
        "  a b c d e f g h"
      moves = ['d2 d4', 'c7 c5', 'd4 c5', 'd8 a5', 'd1']

      allow(new_game).to receive(:gets).and_return(*moves, quit)
      expect(new_game).to receive(:puts).with(expected)

      new_game.setup_board
      moves.length.times do
        new_game.play_turn
      end
      new_game.display_board
    end


  end
end