require_relative '../lib/chess'

describe Chess do
  subject(:new_game) { described_class.new }

  describe '#display_board' do
    it 'displays the board in a new game state' do
      expected = \
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
      expect(new_game).to receive(:puts).with(expected)
      new_game.setup_board
      new_game.display_board
    end
  end
end