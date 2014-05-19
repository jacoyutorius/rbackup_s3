require "rubygems"
require "yaml"
require "pp"
require "aws-sdk"
require "./rbs3_object_collection"

describe "App setting spec" do 

	it{
		AWS::S3::ObjectCollection.method_defined?(:find).should be_true
	}

	it{
		AWS::S3::ObjectCollection.method_defined?(:filter_by_key).should be_true
	}

	before{
		setting = YAML::load(File.open("./setting.yml"))[0]

		@s3 = AWS::S3.new(
      access_key_id: setting["AWS_ACCESS_KEY_ID"],
      secret_access_key: setting["AWS_SECRET_ACCESS_KEY"]
    )
		@s3objectCollection = @s3.buckets["yuto-rbackup-test"].objects
	}


	it{
		@s3objectCollection.find("sample5.txt").should be_true
	}

	it{
		@s3objectCollection.filter_by_key("sample5.txt").class.should be Array
	}

	it{
		@s3objectCollection.filter_by_key("sample5.txt")[0].key.should eq "sample5.txt"
	}

end