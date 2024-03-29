# frozen_string_literal: true

require './color'
require './player'
require './guess_pool'
require './compare_color'

# Computer will select the secret colors for player to guess it
class Game
  include Color

  MAX_TURNS = 12
  def initialize
    @player = Player.new
  end

  def play
    if @player.role == 'guesser'
      play_guesser
    else
      play_creator
    end
  end

  protected

  def play_guesser
    @secret_color = Color.secret_color
    (1..MAX_TURNS).each do |round_num|
      display_layout(round_num)
      break if bingo?
    end
    puts result
  end

  def play_creator
    @pool = GuessPool.new
    show_input_remark
    @secret_color = enter_colors
    (1..MAX_TURNS).each do |round_num|
      display_layout(round_num)
      break if bingo?
    end
    puts result
  end

  def show_input_remark
    print "Enter #{@player.role == 'guesser' ? 'your guess' : 'the secret colors'} "
    puts '(Leave space between each color, e.g. "Black Yellow Red Blue")'
    puts "Color options: #{display_options}"
  end

  def display_layout(round_num)
    puts '------------------------------------------------------------------------------------'
    puts "[Round #{round_num}]"

    if @player.role == 'guesser'
      show_input_remark
      @guess = enter_colors
    else
      com_guess
    end
    puts ''

    puts feedback
  end

  def enter_colors
    loop do
      print '> '
      inputted_colors = gets.chomp.split.map! { |color| color.strip.downcase }
      return inputted_colors if valid_input?(inputted_colors)
    end
  end

  def com_guess
    @guess = @pool.random_guess
    puts "Computer guess: #{@guess.join(' ')}"

    @pool.add_guess(@guess, correct_position, correct_color)
    @pool.update
  end

  def valid_input?(inputted_colors)
    validity = inputted_colors.length == 4 && inputted_colors.all? { |color| Color.valid_color?(color) }
    puts 'Invalid input. Please try again' unless validity
    validity
  end

  def feedback
    "Correct Position: #{correct_position} | Correct Color: #{correct_color}"
  end

  def correct_position
    CompareColor.same_position(@guess, @secret_color)
  end

  def correct_color
    CompareColor.same_color(@guess, @secret_color) - correct_position
  end

  def bingo?
    correct_position == 4
  end

  def result
    if @player.role == 'guesser'
      bingo? ? 'Congrat! You got the correct answer!' : "You lose! The secret color is #{@secret_color.join(', ')}."
    else
      bingo? ? 'Computer got the correct answer!' : "Oops! Computer can't get the secret color."
    end
  end
end

game = Game.new
game.play
