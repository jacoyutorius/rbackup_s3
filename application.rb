require "rubygems"
require "yaml"
require "aws-sdk"
require "pp"

class RBackupS3

  def self.run argv


    if ARGV.length <= 0
      raise "please select upload files..."
    end

    YAML::load(File.open("setting.yml")).each do |setting|

      s3 = connect_s3 setting


      # buckt's version option is required
      unless s3.buckets[setting["BUCKET_NAME"]].versioned? 
        puts "the buckert is not version controled! please enable versioning option."
        return 
      end


      # remove the object if expired.
      s3.buckets[setting["BUCKET_NAME"]].objects.each do |obj|

        # issue #2
        # 対象期間+保存した日 = 実行時の日付であれば削除しない


        obj.versions.each do |v|
          pp v
          # next if v.last_modified.to_date.next_day(setting["SAVE_PERIOD"]) >= Time.now.to_date
          # puts "#{v.version_id} deleted"
          # v.delete
        end
      end


      # uploading
      ARGV.each do |file|
        pp s3.buckets[setting["BUCKET_NAME"]].objects[file].write(:file => file)
      end
    end
  end
  

  def self.connect_s3 setting
    s3 = AWS::S3.new(
          access_key_id: setting["AWS_ACCESS_KEY_ID"],
          secret_access_key: setting["AWS_SECRET_ACCESS_KEY"]
        )
  rescue exeption
    pp exeption
  end
end