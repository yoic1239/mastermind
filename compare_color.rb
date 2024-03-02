# frozen_string_literal: true

# Methods to compare two color sets
module CompareColor
  def self.same_position(set1, set2)
    num = 0
    set1.each_index do |index|
      num += 1 if set1[index] == set2[index]
    end
    num
  end

  def self.same_color(set1, set2)
    num = 0
    set1.tally.each do |color, count|
      num += [count, set2.tally[color]].min if set2.tally.key?(color)
    end
    num
  end
end
