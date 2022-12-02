# Write a function that compares two arrays. The function should return true
# if every value in the first array has its corresponding value squared in the
# second array. The frequency of the values must be the same

# helper method for counting each appearance (establish or increment)
def count_freq(array, hash)
    for num in array
        hash[num] = (hash[num] || 0) + 1
    end
end

def check_squares(array1, array2)
    # return if lengths are not equal
    return false if array1.length != array2.length
    # create a hash for each array's count
    count1 = Hash.new
    count2 = Hash.new
    # execute helper method
    count_freq(array1, count1)
    count_freq(array2, count2)
    # use each enumerator to compare hashes - 
    # return false if there is no key ** 2 with the same value
    count1.each do |key, value|
        return false if value != count2[key ** 2]
    end
    true
end

puts check_squares([1, 2, 4, 1], [1, 16, 4, 1])

# => true