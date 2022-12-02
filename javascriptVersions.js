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

