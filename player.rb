# frozen_string_literal: true

# Allow player to choose their row
class Player
  attr_reader :role

  def initialize
    @role = choose_role
  end

  def choose_role
    role = ''
    loop do
      puts 'Which role would you like to play? Enter "1" for Guesser and "2" for Creator'
      role = gets.chomp.strip
      break if %w[1 2].include?(role)

      puts 'Invalid input. Please try again.'
    end
    role = role == '1' ? 'guesser' : 'creator'
  end
end
