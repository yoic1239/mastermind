# frozen_string_literal: true

# Color options available in the game
module Color
  @@color = %w[blue red green yellow black white]

  def colors
    @@color
  end

  def display_options
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

  def self.colors_by_num(num)
    num_set = num.to_s.split('').map(&:to_i)
    return [] unless num.between?(1111, 6666) && num_set.all? { |digit| digit.between?(1, 6) }

    num_set.map { |digit| @@color[digit - 1] }
  end
end
