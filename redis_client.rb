# coding: utf-8
require "rubygems"
require "pathname"
require "yaml"
require "redis"
class RedisTools
	# connect redis database
	def initialize
		path = File.join(File.dirname(Pathname.new(__FILE__).realpath.to_path))
		redis_path = YAML::load(File.read(File.join(path , 'config' , 'redis.yml')))
		@redis = Redis.new(host: redis_path["host"], port: redis_path["port"], db: redis_path["db"])
	end

	#delete key
	def delete(key, value = nil)
		key_type = @redis.type(key)
		status = false
		if key_type.eql?("string")
			@redis.del(key)
			status = true
		elsif key_type.eql?("hash")# del hash -- hdel hash field
			unless value.empty?
				@redis.hdel(key, value)
				status = true
			else
				@redis.del(key)
				status = true
			end
		elsif key_type.eql?("list")# delete all target value in list
			unless value.empty?
				@redis.lrem(key, 0 ,value)
				status = true
			end
		elsif key_type.eql?("set")
			unless value.empty?
				@redis.srem(key, value)
				status = true
			end
		end
		return status
	end

	def delete_values_in_set(key, value)#value is an array
		value.each do |item|
			@redis.srem(key, item)
		end
		return true
	end

	def delete_values_in_zset(key, value, delete_way)#value is an array
		status = false
		if delete_way.eql?("element")
			value.each do |item|
				@redis.zrem(key, item)
			end
			status = true
			return status
		end
		if delete_way.eql?("range")
			@redis.zremrangebyrank(key,value[0],value[1])
			status = true
			return status
		end
		if delete_way.eql?("score")
			@redis.zremrangebyscore(key, value[0], value[1])
			status = true
			return status
		end
	end


	#write key through different way
	def write_list_or_hash(key)
		begin
			status = true
			block_element = yield
			unless block_element.empty?
				if block_element.class.to_s.eql?("Array")
					block_element.each do |item|
						@redis.lpush(key, item)
					end
				elsif block_element.class.to_s.eql?("Hash")
					hash_list = [key]
					block_element.keys.each do |item|
						hash_list << item
						hash_list << block_element[item]
					end
					@redis.hmset(hash_list)
				end
			end
		rescue
			status = false
		end
		return status
	end

	def write_set_or_zset(key)
		begin
			status = true
			block_element = yield
			unless block_element.empty?
				if block_element.class.to_s.eql?("Array")
					@redis.sadd(key, block_element)
				elsif block_element.class.to_s.eql?("Hash")
				 	 zset_list = []
				 	 block_element.keys.each do |item|
				 	 	zset_list << block_element[item]
				 	 	zset_list << item
				 	 end
				 	 @redis.zadd(key, zset_list)
				end
			end
		rescue
			status = false
		end
		return status
	end	

	def rewrite_list_or_hash(key)
		begin
			status = true
			block_element = yield
			unless block_element.empty?
				@redis.del(key)
				if block_element.class.to_s.eql?("Array")
					@redis.lpush(key, block_element)
				elsif block_element.class.to_s.eql?("Hash")
					hash_list = [key]
					block_element.keys.each do |item|
						hash_list << item
						hash_list << block_element[item]
					end
					@redis.hmset(hash_list)
				end
			end		
		rescue
			status = false
		end
		return status
	end

	def rewrite_set_or_zset(key)
		begin
			status = true
			block_element = yield
			unless block_element.empty?
				@redis.del(key)
				if block_element.class.to_s.eql?("Array")
					@redis.sadd(key, block_element)
				elsif block_element.class.to_s.eql?("Hash")
				 	 zset_list = []
				 	 block_element.keys.each do |item|
				 	 	zset_list << block_element[item]
				 	 	zset_list << item
				 	 end
				 	 @redis.zadd(key, zset_list)
				end
			end
		rescue
			status = false
		end
		return status
	end

	#fetch key value
	def get_element(key)
		key_type = @redis.type(key)
		return_value = nil
		if key_type.eql?("none")
			return return_value
		elsif key_type.eql?("string")
			return_value = @redis.get(key)
		elsif key_type.eql?("hash")
			return_value = @redis.hgetall(key)
		elsif key_type.eql?("list")
			return_value = @redis.lrange(key, 0, -1)
		elsif key_type.eql?("set")
			return_value = @redis.smembers(key)
		elsif key_type.eql?("zset")
			return_value = @redis.zrange(key, 0, -1)
		end
		return return_value
	end
end