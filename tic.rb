class Player
  attr_reader :name, :color
  def initialize(input)
    @name = input.fetch(:name)
    @color = input.fetch(:color)
  end
end

class Cell
  attr_accessor :value
  def initialize(value = "")
    @value = value
  end
end

class Array
  def all_same?
    self.all? {|element| element == self[0]} 
  end

  def all_string?
    self.all? {|element| element == String}
  end
end

class Board
  attr_reader :board
  def initialize(input = {})
    @board = input.fetch(:grid, default_grid)
  end

  def get_position(row_index, column_index)
    return (row_index * @board.size) + column_index + 1
  end

  def format_board
    board.each_with_index do |row, row_index|
      row.each_with_index.map do |column, column_index|
        if column.value == "O" || column.value == "X"
          print column.value
        else
          column.value = get_position(row_index, column_index)
          print column.value
        end
        print "|" if column_index < 2
      end
      print "\n"
    end
  end

  def make_move(move, color)
    choices = {"1" => [0,0],
               "2" => [0,1],
               "3" => [0,2],
               "4" => [1,0],
               "5" => [1,1],
               "6" => [1,2],
               "7" => [2,0],
               "8" => [2,1],
               "9" => [2,2]
              }
    x, y = choices[move]
    change_piece(x, y, color)
  end

  def change_piece(x, y, color)
    board[x][y].value = color
  end

  def winning_position_values(winning_position)
    winning_position.map do|cell| 
      cell.value
    end
  end

  def get_diagonals
    [
      [board[0][0], board[1][1], board[2][2]],
      [board[0][2], board[1][1], board[2][0]]
    ]
  end

  def winner?
    winning_solutions = board + board.transpose + get_diagonals
      winning_solutions.each do |winning_position|
        return true if winning_position_values(winning_position).all_same? == true
      end
  end

  def draw?
    storage = []
    board.flatten.each do |cell|
      storage << cell.value.class
    end

    storage.all_string? ? true : false

  end

  private

  def default_grid
    Array.new(3) {Array.new(3) {Cell.new}}
  end
end

class TicTacToe
  attr_accessor :players, :board, :current_player, :other_player
  def initialize(players, board = Board.new)
    @board = board
    @current_player, @other_player = players
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  def play
    board.format_board
    print "\n"
    puts "#{@current_player.name}, please pick a position?"
    print "\n"
    board.make_move(gets.chomp, @current_player.color)
    if board.winner? == true
      puts "#{@current_player.name} is the winner!!"
      board.format_board
      return false
    elsif board.draw? == true
      puts "Nobody won! It is a draw game!"
      board.format_board
      return false
    else
      switch_players
    end
  end
end

puts "What's your name Player 1?"
name1 = gets.chomp
player1 = Player.new(:name => name1, :color => "O")

puts "What's your name Player 2?"
name2 = gets.chomp
player2 = Player.new(:name => name2, :color => "X")

players = [player1, player2]
game = TicTacToe.new(players)

while(game.play != false) do
  game.play
end