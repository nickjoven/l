const countFrequencyInString = (string, hash) => {
    string = string.toLowerCase()
    for (let i = 0; i < string.length; i++) {
        hash[string[i]] = (hash[string[i]] || 0) + 1
    }
}

const validAnagram = (string1, string2) => {
    if (string1.length !== string2.length) {
        return false
    }
    const letters1 = {}
    const letters2 = {}
    countFrequencyInString(string1, letters1)
    countFrequencyInString(string2, letters2)
    console.log(Object.entries(letters1))
    for (const [letter, freq] of Object.entries(letters1)) {
        if (freq !== letters2[letter]) {
            return false
        }
    }
    return true
}

const twoSum = (numbers, target) => {
    let left = 0
    let right = numbers.length - 1
    while (left < right) {
        let sum = numbers[left] + numbers[right]
        if (sum === target) {
            return [left + 1, right + 1]
        } else {
            sum > target ? right-- : left++
        }
    }
}

// works on non sorted array
const averagePair = (numbers, target) => {
    const hash = {}
    for (let i = 0; i < numbers.length; i++) {
        const check = ((target * 2) - numbers[i])
        if (hash[check]) {
            return true
        }
        hash[numbers[i]] = check
    }
    return false
}

// only works on sorted array
const averagePairPointers = (numbers, target) => {
    let left = 0
    let right = numbers.length - 1
    while (left < right) {
        const check = (numbers[left] + numbers[right]) / 2
        if (check === target) {
            return true
        }
        else if (check > target) {
            right--
        }
        else {
            left++
        }
    }
    return false
}

const convertArray = (int) => {
    const result = []
    let copy = int
    while (copy > 0) {
        result.push(copy % 10)
        copy = Math.floor(copy / 10)
    }
    return result
}

const countFrequency = (arr) => {
    const hash = {}
    arr.forEach((i) => {
        if (hash[i]) {
            hash[i] = hash[i] + 1
        }
        else hash[i] = 1
    })
    return hash
}

const sameFrequency = (num1, num2) => {
    // good luck. Add any arguments you deem necess.
    if (num1 === num2) {
        return true
    }
    const digits1 = convertArray(num1)
    const digits2 = convertArray(num2)
    const hash1 = countFrequency(digits1)
    const hash2 = countFrequency(digits2)
    for (const [k, v] of Object.entries(hash1)) {
        if (v !== hash2[k]) return false
    }
    return true
}

sameFrequency(182, 281) // true
sameFrequency(34, 14) // false
sameFrequency(3589578, 5879385) // true
sameFrequency(22, 222) // false

const areThereDuplicates = () => {
    const hash = {}
    for (const [k, v] of Object.entries(arguments)) {
        if (hash[v]) {
            return true
        }
        hash[v] = 1
    }
    return false
}

const areThereDuplicatesOneLiner = () => {
    return new Set(arguments).size === arguments.length
}

const power = (base, exponent) => {
    if (exponent === 0) return 1
    return base * power(base, exponent - 1)
}


const isSubsequence = (subsequence, string) => {
    // use two pointers
    if (subsequence.length > string.length) return false
    let i = 0
    let j = 0
    while (i < subsequence.length && j < string.length) {
        if (subsequence[i] == string[j]) {
            i += 1
        }
        j += 1
    }
    return i === subsequence.length
}

const maxSubarraySum = (nums, n) => {
    if (n > nums.length) return null
    let max = 0
    let i = 0
    while (i < n) {
        max += nums[i]
        i += 1
    }
    let temp = max
    while (i < nums.length) {
        // sliding window: new temp is old temp - old first element plus new element
        temp = temp - (nums[i - n]) + (nums[i])
        max = max > temp ? max : temp
        i++
    }
    return max
}

const minSubArrayLen = (n, nums) => {
    // takes array of unsorted integers
    // tries to find smallest subarray whose sum
    // is greater than n 
    // returns length of subarray or 0
    if (nums.length === 0) return 0
    let len = Infinity
    let i = j = sum = 0
    while (i < nums.length) {
        if (sum < n && j < nums.length) {
            sum += nums[j]
            j++
            continue;
        } else if (sum >= n) {
            len = len < j - i ? len : j - i
            sum -= nums[i]
            i++
            continue;
        } else {
            break;
        }
    }
    return len === Infinity ? 0 : len
}

const gt = (a, b) => {
    return a > b ? a : b
}

const lengthOfLongestSubstring = (s) => {
    if (s.length === 0) return 0
    if (s.length === 1) return 1
    let h = {}
    let count = 0
    let start = 0
    for (let i = 0; i < s.length; i++) {
        let cur = s[i]
        if (h[cur] || h[cur] === 0) {
            start = gt(start, (h[cur]))
        }
        h[cur] = i + 1
        count = gt(count, (i - start + 1))
    }
    return count
}

const binarySearch = (array, target) => {
    let left = 0
    let right = array.length - 1
    let middle = Math.floor((left + right) / 2)
    while (array[middle] !== target && left <= right) {
        if (target < array[middle]) {
            right = middle - 1
        } else left = middle + 1
        middle = Math.floor((left + right) / 2)
    }
    return array[middle] === target ? middle : -1
}
const factorial = (n) => {
    if (n === 0) return 1
    return n * factorial(n - 1)
}
