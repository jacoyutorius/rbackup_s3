require "rubygems"
require "yaml"
require "aws-sdk"
require "pp"

class RBackupS3

  def self.run argv

    check_args argv

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

          setting["SAVE_PERIOD"].each do |period|

            next if v.last_modified.to_date.next_day(period) == Time.now.to_date
            
            puts "delete #{v.version_id} : saved at #{v.last_modified}" 
            v.delete
   
          end
        end
      end


      # upload
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


  def self.check_args argv

    raise "please select upload files..." if argv.length <= 0

    raise "'setting.yml' does not exists!" unless File.exists? "setting.yml"

  end
end