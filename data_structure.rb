module DataStructure
	class Array
		def initialize
			@items = []
		end

		def add(element)
			@items << element
			p "element add success!"
		end

		def delete(element=nil, index=nil)
			if element.nil? && !index.nil?
				@items.delete_at(index)
			elsif !element.nil?
				@items.delete(element)
			end
			p "element delete success!"
		end

		def size
			return @items.size
		end
	end

	class NewHash
		def initialize
			@items = Hash.new
		end

		def add(key, value)
			@items.store(key, value)
			p "element add success!"
		end

		def delete_by_key(key)
			if @items.has_key?(key)
				@items.delete(key)
			else
				p "element not exist!"
			end
		end

		def delete_by_value(value)
			if @items.has_value?(value)
				key = @items.key(value)
				@items.delete(key)
			else
				p "value not exist!"
			end
		end
	end

	class Stack
		def initialize
			@items = []
		end

		def push(element)
			@item << element
		end

		def pop
			@items.delete_at(@items.size - 1)
		end

		def size
			return @items.size
		end
	end

	class Queue
		def initialize
			@items = []
		end

		def add(element)
			@items << element
		end

		def kick_out
			@items.delete_at(0)
		end

		def size
			return @items.size
		end
	end
