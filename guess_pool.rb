# frozen_string_literal: true

require './color'
require './compare_color'

# Pool of all possible guesses for computer to guess the secret colors
class GuessPool
  include Color
  include CompareColor

  def initialize
    @pool = []
    @guesses = []
    create_guess_pool
  end

  def create_guess_pool
    (1111..6666).each do |num|
      color_set = Color.colors_by_num(num)
      @pool.push(color_set) unless color_set == []
    end
  end

  def add_guess(guess, num_position, num_color)
    @guesses.push({ guess: guess, num_position: num_position, num_color: num_color })
  end

  def update
    udt_pool_by_col
    udt_pool_by_pos
  end

  def udt_pool_by_col
    case @guesses.last[:num_position] + @guesses.last[:num_color]
    when 0
      del_any_icld_colors
    when 4
      del_diff_comb
    else
      del_same_comb
      del_not_icld_colors
    end
  end

  def udt_pool_by_pos
    case @guesses.last[:num_position]
    when 0
      del_any_same_position
    when 1..3
      del_less_same_position(@guesses.last[:num_position])
    end
  end

  def random_guess
    @pool[rand(@pool.length)]
  end

  protected

  def del_any_icld_colors
    @pool.delete_if { |opt| CompareColor.same_color(opt, @guesses.last[:guess]).positive? }
  end

  def del_not_icld_colors
    @pool.delete_if { |opt| CompareColor.same_color(opt, @guesses.last[:guess]).zero? }
  end

  def del_diff_comb
    @pool.delete_if { |opt| CompareColor.same_color(opt, @guesses.last[:guess]) != 4 }
  end

  def del_same_comb
    @pool.delete_if { |opt| CompareColor.same_color(opt, @guesses.last[:guess]) == 4 }
  end

  def del_any_same_position
    @pool.delete_if { |opt| CompareColor.same_position(opt, @guesses.last[:guess]).positive? }
  end

  def del_less_same_position(corr_position)
    @pool.delete_if { |opt| CompareColor.same_position(opt, @guesses.last[:guess]) < corr_position }
  end
end
