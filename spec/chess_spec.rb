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

      allow(new_game).to receive(:gets).and_return(move)
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

      allow(new_game).to receive(:gets).and_return(*moves)
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

      allow(new_game).to receive(:gets).and_return(*moves, 'quit')
      expect(new_game).to receive(:puts).with(expected)

      new_game.setup_board
      moves.length.times do
        new_game.play_turn
      end
    end

    it 'displays castling' do
      expected = \
        "  a b c d e f g h\n" + \
        "8 . .(♚)♜(.)♝ ♞ ♜ 8\n" + \
        "7 ♟ ♟ ♟ ♛ ♟ ♟ ♟ ♟ 7\n" + \
        "6 . . ♞ ♟ ♝ . . . 6\n" + \
        "5 . . . . . . . . 5\n" + \
        "4 . . . . . . . . 4\n" + \
        "3 . . . . . ♘ ♙ . 3\n" + \
        "2 ♙ ♙ ♙ ♙ ♙ ♙ ♗ ♙ 2\n" + \
        "1 ♖ ♘ ♗ . ♕ ♖ ♔ . 1\n" + \
        "  a b c d e f g h"
      moves = ['g1 f3', 'd7 d6', 'g2 g3', 'c8 e6', 'f1 g2', 'd8 d7', 'e1 g1', 'b8 c6', 'd1 e1', 'e8 c8']

      allow(new_game).to receive(:gets).and_return(*moves)
      expect(new_game).to receive(:puts).with(expected)

      new_game.setup_board
      moves.length.times do
        new_game.play_turn
      end
      new_game.display_board
    end

    it 'displays pawn promotion' do
      expected = \
        "  a b c d e f g h\n" + \
        "8(♘). ♝ ♛ ♚ ♝ ♞ ♜ 8\n" + \
        "7(.). ♟ ♟ ♟ ♟ ♟ ♟ 7\n" + \
        "6 . . ♞ . . . . . 6\n" + \
        "5 . . . . . . . . 5\n" + \
        "4 . . . . . . . . 4\n" + \
        "3 . . . . . . . . 3\n" + \
        "2 ♙ . ♙ ♙ ♙ ♙ ♙ ♙ 2\n" + \
        "1 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ 1\n" + \
        "  a b c d e f g h"
      moves = ['b2 b4', 'a7 a5', 'b4 a5', 'b7 b5', 'a5 b6', 'a8 a7', 'b6 a7', 'b8 c6', 'a7 a8']
      promotion_message = 'Select piece to promote pawn to (queen/knight):'
      promotion = 'knight'

      allow(new_game).to receive(:gets).and_return(*moves, promotion)
      expect(new_game).to receive(:puts).with(promotion_message)

      new_game.setup_board
      moves.length.times do
        new_game.play_turn
      end

      expect(new_game).to receive(:puts).with(expected)
      new_game.display_board
    end

  end

  describe '#load_game' do
    it 'loads the En Passant state correctly' do
      moves_before = ['a2 a4', 'a7 a6', 'a4 a5', 'b7 b5']
      before = \
        "  a b c d e f g h\n" + \
        "8 ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜ 8\n" + \
        "7 .(.)♟ ♟ ♟ ♟ ♟ ♟ 7\n" + \
        "6 ♟ . . . . . . . 6\n" + \
        "5 ♙(♟). . . . . . 5\n" + \
        "4 . . . . . . . . 4\n" + \
        "3 . . . . . . . . 3\n" + \
        "2 . ♙ ♙ ♙ ♙ ♙ ♙ ♙ 2\n" + \
        "1 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ 1\n" + \
        "  a b c d e f g h"
      moves_after = ['a5 b6']
      after = \
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
      
      allow(new_game).to receive(:gets).and_return(*moves_before)
      expect(new_game).to receive(:puts).with(before)

      new_game.setup_board
      moves_before.length.times do
        new_game.play_turn
      end
      new_game.save_game
      new_game.load_game
      new_game.display_board
      
      allow(new_game).to receive(:gets).and_return(*moves_after)
      expect(new_game).to receive(:puts).with(after)
      
      moves_after.length.times do
        new_game.play_turn
      end
      new_game.display_board
    end

  end

end