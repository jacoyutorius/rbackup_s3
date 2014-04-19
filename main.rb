require "rubygems"
require "yaml"
require "aws-sdk"
require "pp"


# remove the object if expired.
def delete_expired_version s3object, save_days=40
  return if s3object.last_modified.to_date.next_day(save_days) >= Time.now.to_date
  
  puts "#{s3object.version_id} deleted"
  s3object.delete
end




if ARGV.length <= 0
  raise "please select upload files..."
end


YAML::load(File.open("setting.yml")).each do |setting|

	s3 = AWS::S3.new(
			access_key_id: setting["AWS_ACCESS_KEY_ID"],
			secret_access_key: setting["AWS_SECRET_ACCESS_KEY"]
		)


  # buckt's version option is required
  unless s3.buckets[setting["BUCKET_NAME"]].versioned? 
    puts "the buckert is not version controled! please enable versioning option."
    return 
  end


  s3.buckets[setting["BUCKET_NAME"]].objects.each do |obj|
  
    p obj.key
    obj.versions.each do |v|
      pp v.last_modified

      delete_expired_version(v, setting["SAVE_PERIOD"])
    end
  end


  # uploading
  ARGV.each do |file|

    puts file
    raise "File does not found." unless File.exist? file

    s3.buckets[setting["BUCKET_NAME"]].objects[file].write(:file => file)

  end

end





