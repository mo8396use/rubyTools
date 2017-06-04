class TestAbility

	def pub
		puts "pub is public method"
		# self.priv
		# prot
	end

	def priv
		puts "access to private method"
	end

	def prot
		puts "is protected method"
	end

	def call_the_prot(instance)
		instance.prot
	end

	def call_the_priv(instance)
		instance.priv
	end

	private :priv
	protected :prot
end

test1 = TestAbility.new
test2 = TestAbility.new
#test1.call_the_priv(test2)
test1.call_the_prot(test2)
