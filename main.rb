require "rubygems"
require "yaml"
require "aws-sdk"
require "pp"


YAML::load(File.open("setting.yml")).each do |setting|


	s3 = AWS::S3.new(
			access_key_id: setting["AWS_ACCESS_KEY_ID"],
			secret_access_key: setting["AWS_SECRET_ACCESS_KEY"]
		)

	s3.buckets.each do |bucket|
		bucket.name
	end
end

