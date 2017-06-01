# coding: utf-8
class Regx

	#regular expression hex
	def exp(s)
		(s =~ /<0(x|X)(\d|[a-f]|[A-F])+>/) != nil
	end

	#regular expression email
	def email_exp(s)
		(s =~ /^(\d|[A-Z]|[a-z])+@(\d|[A-Z]|[a-z])+(.)[a-z]+/) != nil
	end

	#regular expression time
	def time_exp(s)
		(s =~ /[0-2][0-9]:[0-5][0-9]:[0-5][0-9]/) != nil
	end
	
	#regular expression command line
	def exp_command_line
		st = "\033[7m"
		en = "\033[m"
		puts "Enter an empty string at any time to exit"
		while true
			print "str> "; STDOUT.flush; str = gets.chop
			break if str.empty?
			print "pat> "; STDOUT.flush; pat = gets.chop
			break if pat.empty?
			re = Regexp.new(pat)
			puts str.gsub(re, "#{st}\\&#{en}")
		end
	end
end