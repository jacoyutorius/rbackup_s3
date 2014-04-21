require "rubygems"
require "yaml"
require "pp"

describe "Yaml setting spec" do 

	before do 
		@setting = YAML::load(File.open("./setting_spec.yml"))[0]
	end

	it "could load setting " do 
		@setting.should_not be_empty
	end

	it "can load access key" do 
		@setting["AWS_ACCESS_KEY_ID"].should == "MY_ACCESS_KEY"
	end

	it "can load secret access key" do 
		@setting["AWS_SECRET_ACCESS_KEY"].should == "MY_ACCESS_SECRET"
	end	

	it "can set multiple save period" do 
		@setting["SAVE_PERIOD"].class.should == Array
	end

end