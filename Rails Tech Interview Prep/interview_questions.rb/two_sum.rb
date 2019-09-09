# From what I remember the question was;
# Given a bag with capacity C as integer value,
# and an int list, find 2 numbers from the list such that we can fill this bag with min space left.
# For example, let the bag capacity C is 10 and
# The array list is [1, 2, 3, 4, 5]
# The answer is clearly [4, 5]

def best_fit(capacity, list)
  listIndexed = {}
  best = nil
  total = list[0]
  list.sort! # if not sorted
  list.each_with_index do |num, index|
    next_num = list[index + 1]
    break if index == list.length
    current = num
    next_index = index + 1
    while current < capacity &&
          total < capacity &&
          !list[next_index].nil? do
      current = list[next_index] + num
      if current > capacity
        break
      elsif total < current
        total = current
        best = [num, list[next_index]]
      end
      next_index += 1
    end
  end

  best
end
