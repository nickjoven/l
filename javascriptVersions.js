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
    console.log(arguments)
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

console.log(areThereDuplicates('a', 'b'))