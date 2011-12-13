if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
elsif Rails.env.production?
  begin
    CarrierWave.configure do |config|
      config.storage = :s3
      config.s3_access_key_id = SITE['s3_access_key_id']
      config.s3_secret_access_key = SITE['s3_secret_access_key'] 
      config.s3_bucket = SITE['s3_bucket']
    end
  end
end
