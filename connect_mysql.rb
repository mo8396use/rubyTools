require "rubygems"
require "pathname"
require "mysql2"
require "yaml"

class ConnectMysql
	def initialize
		path = File.join(File.dirname(Pathname.new(__FILE__).realpath.to_path))
		database = YAML::load(File.read(File.join(path , 'config' , 'database.yml')))
		@mysql_client = Mysql2::Client.new(host: database["host"] , username: database["username"] , password: database["password"] , database: database["database"] , port: database["port"])
	end

	#insert a message into table
	def single_insert(table_name, hash)
		status = true
		begin
			columns = []
			values = []
			hash.keys.each do |item|
				columns.push(item)
				values.push("'#{hash[item]}'")
			end
			columns = columns.join(",")
			values = values.join(",")
			@mysql_client.query("INSERT INTO #{table_name} (#{columns}) VALUES (#{values})")
		rescue
			status = false
		end
		return status
	end
	
	#delete a table message or single message
	def single_delete(table_name, id=nil)
		status = true
		begin
			sql = "DELETE FROM #{table_name}"
			sql << "WHERE id = #{id}" unless id.nil?
			@mysql_client.query(sql)
		rescue
			status = false
		end
		return status
	end

	def close_connection
		@client.close
	end
end	