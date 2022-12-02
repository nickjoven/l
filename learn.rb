# Compare Squares

# Write a function that compares two arrays. The function should return true
# if every value in the first array has its corresponding value squared in the
# second array. The frequency of the values must be the same

# helper method for counting each appearance (establish or increment)
def count_freq(enumerable, hash)
    for i in enumerable
        hash[i] = (hash[i] || 0) + 1
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

puts check_squares([10, 20, 4, 1], [1, 16, 4, 1])
# => false
# Anagrams

# Given two strings, write a function to determine if the second string is an
# anagram of the first string. Basically the exact same as above since a string
# can be indexed like an array

# helper method needs to be adjusted for strings, though... downcase for case insensitivity and do for i in 0..string.length - 1

def count_freq_string(string, hash)
    string = string.downcase
    for i in 0..string.length - 1
        hash[string[i]] = (hash[string[i]] || 0) + 1 
    end
  puts hash
end

def valid_anagram(s, t)
        # compare appearance + frequency of letters in each string
    return false if s.length != t.length
    letters1 = Hash.new
    letters2 = Hash.new
    count_freq_string(s, letters1)
    count_freq_string(t, letters2)
    letters1.each do |letter, count_of|
        return false if count_of != letters2[letter]
    end
    true
end

puts valid_anagram("dog", "good")
# => false

puts valid_anagram("iceman", "cinema")
# => true

