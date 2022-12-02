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

# sum_zero

# Write a function called sum_zero that accepts a sorted array
# of integers. The function should find the first pair where the
# sum is zero. Return an array that includes both values or
# false if a pair does not exist

def sum_zero(array)
  # could compare every number against every number (at least O(n^2))
  # should ideally do 1 loop (possible using two pointers)
  left = 0
  right = array.length - 1
  while left < right
    left_val = array[left]
    right_val = array[right]
    sum = left_val + right_val
    return [left_val, right_val] if sum == 0
    # because the array is sorted, left is the smallest number
    # right is always the largest number
    # if the sum is greater than 0, you need the sum to be smaller
    # so you decrement right, and likewise increment left if the 
    # sum is less than zero (meaning you need a larger number)
    sum > 0 ? right -= 1 : left += 1
  end
  return false
end

puts sum_zero([-4, -3, -2, -1, 0, 1, 2, 5])

# => 2, -2

# LC medium that uses the same concept: 167

# Given a 1-indexed array of integers numbers that is already 
# sorted in non-decreasing order, find two numbers such that they 
# add up to a specific target number. Let these two numbers be 
# numbers[index1] and numbers[index2] where 1 <= index1 < index2 
# <= numbers.length.
# Return the indices of the two numbers, index1 and index2, added
# by one as an integer array [index1, index2] of length 2.

# The tests are generated such that there is exactly one solution. 
# You may not use the same element twice.

# Your solution must use only constant extra space.

def two_sum(numbers, target)
    # leverage the sorted array with a left pointer and a right pointer
    left = 0
    right = numbers.length - 1
    while left < right
        sum = numbers[left] + numbers[right]
        return [left + 1, right + 1] if sum == target
        sum > target ? right -= 1 : left += 1
    end
end

puts two_sum([2,7,11,15], 9)

# count_unique_values

# Implement a function called count_unique_values that accepts
# a sorted array, and counts the unique values in the array.
# There can be negative numbers in the array, but it will always
# be sorted.

# consider using a set - O(n)
def count_unique_values_one_line(numbers)
  return numbers.length == 0 ? 0 : set = Set.new(numbers).size
end

def count_unique_values(numbers)
    return 0 if numbers.length == 0
    i = 0
    j = 1
    while j < numbers.length
        if arr[i] != arr[j]
            i += 1
            arr[i] = arr[j]
        end
        j += 1
    end 
    i + 1
end

puts count_unique_values([1, 2, 3, 4, 4, 5, 6, 6, 6, 7, 7, 8])

# similar problem
#  Given an array of integers arr, return true if the number of 
# occurrences of each value in the array is unique or false otherwise.

def unique_occurrences(arr)
    return arr[0] == arr[1] if arr.length == 2 
    return true if arr.length == 1
    hash = Hash.new
    set = Set.new
    arr = arr.sort
    for i in 0..arr.length - 1
        curr = arr[i]
        inc = arr[i + 1]
        hash[curr] ? hash[curr] += 1 : hash[curr] = 1
        set.add(hash[curr]) unless (inc && curr == inc)
    end
    set.size == hash.size
end