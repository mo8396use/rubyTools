class HelloWorld
	VERSION = "1.0"
	attr_accessor :name
	def initialize(myname = "ruby")
		@name = myname
	end

	def hello
		puts "I am #{@name}"
	end

	# def greeting
	# 	puts "I am #{name}"
	# end
	# def name
	# 	@name
	# end

	# def name=(value)
	# 	@name = value
	# end
end
p HelloWorld::VERSION
bob = HelloWorld.new("bob")
p bob
bob.name = "sis"
p bob.name