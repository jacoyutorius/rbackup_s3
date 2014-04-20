require "rubygems"
require "yaml"
require "aws-sdk"
require "pp"

class RbackupS3::Application

  def self.run argv

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


      # remove the object if expired.
      s3.buckets[setting["BUCKET_NAME"]].objects.each do |obj|
        # p obj.key
        obj.versions.each do |v|
          pp v.last_modified
          # delete_expired_version(v, setting["SAVE_PERIOD"])

          next if s3object.last_modified.to_date.next_day(save_days) >= Time.now.to_date
          puts "#{s3object.version_id} deleted"
          s3object.delete
        end
      end


      # uploading
      ARGV.each do |file|

        # raise "File does not found.. #{file}" unless File.exist? file
        s3.buckets[setting["BUCKET_NAME"]].objects[file].write(:file => file)

      end
    end
  end


  # # remove the object if expired.
  # def delete_expired_version s3object, save_days=40
  #   return if s3object.last_modified.to_date.next_day(save_days) >= Time.now.to_date
    
  #   puts "#{s3object.version_id} deleted"
  #   s3object.delete
  # end

end
