class ProviderAuthorization < ActiveRecord::Base
  validates_presence_of :member_id
  validates_presence_of :provider
  validates_presence_of :uid
  validates_uniqueness_of :provider, :scope => :member_id
  validates_uniqueness_of :uid, :scope => :provider

  belongs_to :member

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    if authorization = ProviderAuthorization.where(:provider => 'facebook', :uid => access_token['uid']).first
      authorization
    else
      m = Member.find_for_facebook_oauth(access_token, signed_in_resource)
      self.create(:member => m, :provider => 'facebook', :uid => access_token['uid'])
    end
  end

  def self.find_for_google_apps_oauth(access_token, signed_in_resource=nil)
    if authorization = ProviderAuthorization.where(:provider => 'google_apps', :uid => access_token['uid']).first
      authorization
    else
      m = Member.find_for_google_apps_oauth(access_token, signed_in_resource)
      # For cases where google does not give us the email address
      return false unless m
      self.create(:member => m, :provider => 'google_apps', :uid => access_token['uid'])
    end
  end
end