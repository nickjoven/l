class SinglyLinkedList
    attr_reader :head, :tail, :length
    
    def initialize
        @head = nil
        @tail = nil
        @length = 0
    end

    def decrement
        @length -= 1
        if length == 0
            @head = nil
            @tail = nil
        end
    end

    def push(value)
        node = Node.new(value)
        if !@head
            @head = node
            @tail = @head
        else
            @tail.next = node
            @tail = node
        end
        @length += 1
        self
    end

    def pop
        return nil if !head
        current = @head
        new_tail = current
        while current.next
            new_tail = current
            current = current.next
        end
        @tail = new_tail
        @tail.next = nil
        decrement
        current
    end

    def shift
        return nil if !head
        current = @head
        @head = current.next
        decrement
        current
    end

    def unshift(value)
        node = Node.new(value)
        if !head
            @head = node
            @tail = node
        else
            node.next = @head
            @head = node
        end
        @length += 1
        self
    end
    
    def print
        node = @head
        while node
            puts node.value
            node = node.next
        end
    end
        
end

class Node
    attr_accessor :next
    attr_reader :value

    def initialize(value)
        @value = value
        @next = nil
    end

    def to_s 
        "#{@value}"
    end
end

# Data Structure    Access      Search      Insertion       Deletion
# Array	            O(1)	    O(n)	    O(n)	        O(n)
# Linked List	    O(n)    	O(n)    	O(1)        	O(1)