require "set"

# Compare Squares

# Write a function that compares two arrays. The function should 
# return true if every value in the first array has its corresponding 
# value squared in the second array. The frequency of the values must 
# be the same

# helper method for counting each appearance (establish or increment)
def count_freq(enumerable)
  hash = Hash.new
    for i in enumerable
        hash[i] = (hash[i] || 0) + 1
    end
  return hash
end

def check_squares(array1, array2)
    # return if lengths are not equal
    return false if array1.length != array2.length
    # create a hash for each array's count
    # execute helper method
    count1 = count_freq(array1)
    count2 = count_freq(array2)
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
# Given two strings, write a function to determine if the second
# string is an anagram of the first string. Basically the exact 
# same as above since a string can be indexed like an array

# helper method needs to be adjusted for strings, though... downcase
# for case insensitivity and do for i in 0..string.length - 1

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

def two_sum_sorted(numbers, target)
    # leverage the sorted array with a left pointer and a right pointer
    left = 0
    right = numbers.length - 1
    while left < right
        sum = numbers[left] + numbers[right]
        return [left + 1, right + 1] if sum == target
        sum > target ? right -= 1 : left += 1
    end
end

puts two_sum_sorted([2,7,11,15], 9)

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
        if numbers[i] != numbers[j]
            i += 1
            numbers[i] = numbers[j]
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

# Sliding window

# The pattern involves creating a window chich can either be an
# array or number from one position to another
# Depending on a certain condition, the window either increases 
# or closes (and a new window is created)
# Useful when tracking a subset of data (like in a string or array)

# Write a function called max_subarray_sum which accepts an array of
# integers and a number called n. The function should calculate the
# maximum sum of n consecutive elements in the array

# constantly updating maximum, two loops are used (but not nested)

def max_subarray_sum(array, num)
    return nil if num > array.length
    max = 0
    i = 0
    while i < num
        max += array[i]
        i += 1
    end
    temp = max
    while i < array.length
        # to "shift" the window we subtract the first index of
        # the previous window (arr[i - num]) and the new end of
        # window arr[i]
        temp = temp - (array[i - num]) + (array[i])
        max = max > temp ? max : temp
        i += 1
    end
    return max
end

puts max_subarray_sum([2, 4, 6, 1, 10, -7], 3)

# similar question, LC 53 - max_sub_array

# Given an integer array nums, find the subarray which has the 
# largest sum and return its sum.

def max_sub_array(nums)
    return nums[0] if nums.length == 1
    max = nums[0]
    temp = nums[0]
    i = 1
    while i < nums.length
        num = nums[i]
        temp = num > num + temp ? num : num + temp
        max = temp > max ? temp : max
        i += 1
    end
    max
end

puts max_sub_array([-2,1,-3,4,-1,2,1,-5,4])


# Write a function called sameFrequency. Given two positive integers, 
# find out if the two numbers have the same frequency of digits.

# uses two helper functions convert_array and count_freq

def convert_array(num)
    result = Array.new
    copy = num
    while copy > 0
        digit = copy % 10
        result << digit
        copy = copy / 10
    end
    result
end

# def count_freq(enumerable)
#   hash = Hash.new
#     for i in enumerable
#         hash[i] = (hash[i] || 0) + 1
#     end
#   return hash
# end


def same_frequency(num1, num2)
    return true if num1 == num2
    digits1 = convert_array(num1)
    digits2 = convert_array(num2)
    hash1 = count_freq(digits1)
    hash2 = count_freq(digits2)
    hash1.each do |k, v|
        return false if hash1[k] != hash2[k]
    end
    return true
end

puts same_frequency(1820, 2081)
puts same_frequency(183,281)

def find_duplicate(nums)
    set = Set.new
    i = 0
    while i < nums.length 
        return nums[i] if set === nums[i]
        set << nums[i]
        i += 1
    end
end

puts find_duplicate([1,3,4,2,2])

# Write a function called average_pair. Given a sorted array of integers and a target average, determine if there is a pair of values in the array where the average of the pair equals the target average. There may be more than one pair that matches the average target.

# Bonus Constraints:

# Time: O(N)

# Space: O(1)

# Sample Input:

# (1 + 2) / 2 = 1.5
# (1 + x) / 2 = 2.5
# (1 + x) = (2.5(2)) - 1
# x = (target * 2) - num

# average_pair([1,2,3],2.5) # true
# average_pair([1,3,3,5,6,7,10,12,19],8) # true
# average_pair([-1,0,3,4,5,6], 4.1) # false
# average_pair([],4) # false

# the array is sorted, therefore two pointers on left
# and right can be used - binary search is o log n because
# you don't iterate over every element in the array:
# you look over half of the array at most, and do a comparison
# of the left and right elements

def average_pair(numbers, target)
    left = 0
    right = numbers.length - 1
    while left < right
        check = ((numbers[left] + numbers[right]) / 2.0)
        return true if check == target.to_f
        check > target ? right -= 1 : left += 1
    end
    return false
end

def average_pair_hash(numbers, target)
    hash = Hash.new
    numbers.each do |num|
        check = ((target * 2) - num).to_f
        return true if hash[check] 
        hash[num.to_f] = check
    end
    return false
end

puts(average_pair([1,2,3],2.5)) # true
puts average_pair([1,3,3,5,6,7,10,12,19],8) # true
puts average_pair([-1,0,3,4,5,6], 4.1) # false

def power(base, exponent)
    return 1 if exponent == 0
    return base * power(base, exponent - 1)
end
# LC 50 Pow(x, n)

# done recursively by accounting for 4 possible scenarios for n
# n == 0
# n < 0
# n % 2 == 0 (even)
# else (odd)

def my_pow(x, n)
    return 1 if n == 0
    return 1 / my_pow(x, -n) if n < 0
    return n % 2 == 0 ? my_pow(x * x, n / 2) : x * my_pow(x, n - 1)
end

# is_subsequence
def is_subsequence(sub, string)
  return false if sub.length > string.length
  i = 0
  j = 0
  # j will go through string
  # i will go through sub
  # since the method is checking subsequence and not substring,
  # we can increment i if string[j] == sub[i] and return
  # i == sub.length
  while j < string.length && i < sub.length
    i += 1 if sub[i] == string[j]
    j += 1
  end
  return i == sub.length
end

puts is_subsequence('hellish', 'hello worldish')

def min_sub_array_len(n, nums)
    return 0 if nums.length == 0
    len = Float::INFINITY
    i = 0
    j = 0
    sum = 0
    while i < nums.length
        if sum < n && j < nums.length
            sum += nums[j]
            j += 1
            next
        elsif sum >= n
            len = len < j - i ? len : j - i
            sum -= nums[i]
            i += 1
            next
        else 
            break
        end
    end
    return len == Float::INFINITY ? 0 : len
end

puts min_sub_array_len(7, [2, 3, 1, 2, 4, 3])
# => 2

def search(nums, target)
    left = 0
    right = nums.length - 1
    midpoint = (left + right) / 2
    while left <= right && nums[midpoint] != target
        target < nums[midpoint] ? right = midpoint - 1 : left = midpoint + 1
        midpoint = (left + right) / 2
    end
    return nums[midpoint] == target ? midpoint : -1
end

puts search(nums = [-1,0,3,5,9,12], target = 9)
# => 4

def factorial(n)
    return 1 if n == 0
    return n * factorial(n - 1)
end
