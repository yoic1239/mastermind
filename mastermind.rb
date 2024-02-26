# frozen_string_literal: true

# Color options available in the game
class Color
  @@color = %w[blue red green yellow black white]

  def self.colors
    @@color.map { |color| color[0].upcase + color[1..] }.join(' / ')
  end

  def self.random
    @@color[rand(@@color.length)]
  end

  def self.secret_color
    secret_color = []
    4.times do
      secret_color.push(random)
    end
    secret_color
  end

  def self.valid_color?(color)
    @@color.include?(color)
  end
end

# Computer will select the secret colors for player to guess it
class Game
  MAX_TURNS = 12
  def initialize
    @secret_color = Color.secret_color
    @guess = []
  end

  def play
    (1..MAX_TURNS).each do |round|
      puts '------------------------------------------------------------------------------------'
      puts "[Round #{round}]"

      enter_guess
      puts ''

      puts feedback
      puts ''

      break if correct_guess?
    end
    puts result
  end

  protected

  def enter_guess
    puts 'Enter your guess (Leave space between each color, e.g. "Black Yellow Red Blue")'
    puts "Color options: #{Color.colors}"
    loop do
      print '> '
      @guess = gets.chomp.split.map! { |color| color.strip.downcase }
      break if @guess.length == 4 && @guess.all? { |color| Color.valid_color?(color) }

      puts 'Invalid input. Please try again.'
    end
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

  def feedback
    "Correct Position: #{correct_position} | Correct Color: #{correct_color}"
  end

  def correct_guess?
    correct_position == 4
  end

  def result
    correct_guess? ? 'Congrat! You got the correct answer!' : "Oops! You can't get the secret color. Let's play again!"
  end
end
