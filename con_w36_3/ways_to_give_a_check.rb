def waysToGiveACheck(board)
    p = Problem.new(board)
    pawn = p.find_target_pawn || raise('unable to find pawn')
    king = p.find_target_king || raise('unable to find king')

    p.promote!(pawn)
    case
      when p.there_is_knight_move(pawn, king) then
        return 1
      when p.there_is_diagonal_move(pawn, king) then
        return 2
      when p.there_is_straight_move(pawn, king) then
        return 2
      when p.discovered_checks(king, pawn) then
        return 4
    else
      return 0
    end
end

def run
  gets.to_i.times do
    board = Array.new(8)
    8.times do |i|
      board[i] = gets.chars
    end
    print waysToGiveACheck(board), "\n"
  end
end

class Problem
  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def discovered_checks
    false
  end

  def there_is_knight_move(a, b)
    [a[0]-b[0], a[1]-b[1]].map(&:abs).sort == [1, 2]
  end

  def inside(a, b)
    a < b ? (a+1..b-1) : (b+1..a-1)
  end

  def including(a, b)
    a < b ? (a..b) : (b..a)
  end

  def there_is_diagonal_move(a, b)
    return false if (a[0]-b[0]).abs != (a[1]-b[1]).abs
    inside(a[0], b[0]).each do |r|
      inside(a[1], b[1]).each do |c|
        p = [r, c]
        return false if board[p[0]][p[1]] != '#' # && p != a && p != b
      end
    end
    true
  end

  def there_is_straight_move(a, b)
    return false if a[0] != b[0] && a[1] != b[1]
    including(a[0], b[0]).each do |r|
      including(a[1], b[1]).each do |c|
        p = [r, c]
        return false if board[p[0]][p[1]] != '#' && p != a && p != b
      end
    end
    true
  end

  def find_target_pawn
    select_by_id('P').each do |cell|
      return cell if cell[0] == 1 && board[0][cell[1]] == '#'
    end
    nil
  end

  def promote!(pawn)
    board[0][pawn[1]] = 'X'
    board[1][pawn[1]] = '#'
    pawn[0] = 0
  end

  def find_target_king
    find_by_id('k')
  end

  def for_each
    8.times do |row|
      8.times do |col|
        yield board[row][col], [row, col]
      end
    end
  end

  def find_by_id(piece)
    for_each do |value, cell|
      return cell if value == piece
    end
    nil
  end

  def select_by_id(piece)
    Enumerator.new do |yielder|
      for_each do |value, cell|
        yielder.yield(cell) if value == piece
      end
    end
  end
end

if defined? RSpec
  RSpec.describe 'methods' do
    let(:board) { ([['#']*8]*8).map &:dup }
    let(:problem) { Problem.new(board) }

    describe 'find_by_id' do
      it 'finds a piece ' do
        board[3][2] = 'X'
        expect(problem.find_by_id('X')).to eq([3, 2])
      end
    end

    describe 'select_by_id' do
      before do
        board[2][5] = 'Y'
        board[7][1] = 'Y'
      end

      it 'yields all occurences' do
        expect(problem.select_by_id('Y').to_a).to eq([[2, 5], [7, 1]])
      end
    end

    describe 'find_target_pawn' do
      it 'ignores occupied 1st line' do
        board[0][3] = 'X'
        board[1][3] = 'P'

        expect(problem.find_target_pawn).to be_nil
      end

      it 'finds good pawns' do
        board[0][3] = 'X'
        board[1][3] = 'P'
        board[1][5] = 'P'

        expect(problem.find_target_pawn).to eq [1, 5]
      end
    end

    describe 'find_target_king' do
      it 'founds k' do
        board[1][3] = 'k'
        expect(problem.find_target_king).to eql [1, 3]
      end
    end

    describe 'promote' do
      let(:pawn) { [1, 5] }
      before do
        board[1][5] = 'P'
        problem.promote!(pawn)
      end

      it 'resets old position' do
        expect(board[1][5]).to eql '#'
      end

      it 'sets new position' do
        expect(board[0][5]).to eql 'X'
      end

      it 'mutates pawn position' do
        expect(pawn).to eql [0, 5]
      end
    end

    describe 'there_is_knight_move' do
      it 'detects the move' do
        expect(problem.there_is_knight_move([4,3], [5,1])).to be_truthy
      end
      it 'returns false if none' do
        expect(problem.there_is_knight_move([3,3], [5,1])).to be_falsey
      end
    end

    describe 'there_is_diagonal_move' do
      let(:a) { [7, 7] }
      let(:b) { [4, 4] }
      let(:c) { [0, 0] }
      let(:x) { [3, 3] }
      let(:z) { [7, 2] }
      before do
        board[3][3] = 'X'
        board[7][7] = 'a'
        board[4][4] = 'b'
        board[0][0] = 'c'
        board[7][2] = 'z'
      end
      it 'founds it' do
        expect(problem.there_is_diagonal_move(a, b)).to be_truthy
      end
      it 'ignores not diagonal paths' do
        expect(problem.there_is_diagonal_move(a, z)).to be_falsey
      end
      it 'detects obstacles' do
        expect(problem.there_is_diagonal_move(a, c)).to be_falsey
      end

      context 'test1' do
        before do
          board[0][6] = 'P'
          board[2][4] = 'k'
        end
        it 'work' do
          expect(problem.there_is_diagonal_move([0,6], [2,4])).to be_truthy
        end
      end
    end

    describe 'there_is_straight_move' do
      let(:a) { [3, 7] }
      let(:b) { [3, 4] }
      let(:c) { [3, 0] }
      let(:x) { [3, 3] }
      let(:z) { [7, 2] }
      before do
        board[3][3] = 'X'
        board[3][7] = 'a'
        board[3][4] = 'b'
        board[3][0] = 'c'
        board[7][2] = 'z'
      end
      it 'founds it' do
        expect(problem.there_is_straight_move(a, b)).to be_truthy
      end
      it 'ignores not straight paths' do
        expect(problem.there_is_straight_move(a, z)).to be_falsey
      end
      it 'detects obstacles' do
        expect(problem.there_is_straight_move(a, c)).to be_falsey
      end
    end
  end
  CPRSpec.once
else
  run
end

