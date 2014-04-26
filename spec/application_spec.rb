require "rubygems"
require "yaml"
require "pp"
require "./application"

describe "App setting spec" do 

	it "raise exception if ARGV is none" do 
		lambda{RBackupS3.run}.should raise_error(ArgumentError) 
	end


end