#coding: utf-8

#block methods example
def block_method(a,b)
	a + yield(a,b)
end
puts block_method(1,2) {|a,b| a*2+b}
result = block_method(1,2) do |a,b|
	a+b*2
end
puts result

def closure_method
	x = "good"
	yield("luohao")
end
x = "hello"
puts closure_method {|y| "#{x} World, #{y}!"}
