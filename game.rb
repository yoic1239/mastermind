# frozen_string_literal: true

require './color'
require './player'

# Computer will select the secret colors for player to guess it
class Game
  include Color

  MAX_TURNS = 12
  def initialize
    @player = Player.new
    @secret_color = []
    @guess = []
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
      display_layout(round_num, true)
      break if correct_guess?
    end
    puts result(true)
  end

  def play_creator
    show_input_remark(false)
    enter_colors(false)
    (1..MAX_TURNS).each do |round_num|
      display_layout(round_num, false)
      break if correct_guess?
    end
    puts result(false)
  end

  def display_layout(round_num, guess_mode)
    puts '------------------------------------------------------------------------------------'
    puts "[Round #{round_num}]"

    if guess_mode
      show_input_remark(guess_mode)
      enter_colors(guess_mode)
    else
      com_guess
    end
    puts ''

    puts feedback
  end

  def enter_colors(guess_mode)
    loop do
      print '> '
      if guess_mode
        @guess = gets.chomp.split.map! { |color| color.strip.downcase }
      else
        @secret_color = gets.chomp.split.map! { |color| color.strip.downcase }
      end
      break if valid_input?(guess_mode)
    end
  end

  def com_guess
    @guess = Color.secret_color
    puts "Computer guess: #{@guess.join(' ')}"
  end

  def show_input_remark(guess_mode)
    print "Enter #{guess_mode ? 'your guess' : 'the secret colors'} "
    puts '(Leave space between each color, e.g. "Black Yellow Red Blue")'
    puts "Color options: #{display_options}"
  end

  def valid_input?(guess_mode)
    check_var = guess_mode ? @guess : @secret_color
    validity = check_var.length == 4 && check_var.all? { |color| Color.valid_color?(color) }
    puts 'Invalid input. Please try again' unless validity
    validity
  end

  def feedback
    "Correct Position: #{correct_position} | Correct Color: #{correct_color}"
  end

  def correct_position
    same_position = 0
    @secret_color.each_with_index do |color, index|
      same_position += 1 if color == @guess[index]
    end
    same_position
  end

  def correct_color
    same_color = 0
    @secret_color.tally.each do |color, count|
      if @guess.tally.key?(color)
        same_color += @guess.tally[color] <= count ? @guess.tally[color] : count
      end
    end
    same_color - correct_position
  end

  def correct_guess?
    correct_position == 4
  end

  def result(guess_mode)
    if guess_mode
      correct_guess? ? 'Congrat! You got the correct answer!' : "Oops! You can't get the secret color."
    else
      correct_guess? ? 'Computer got the correct answer!' : "Oops! Computer can't get the secret color."
    end
  end
end
