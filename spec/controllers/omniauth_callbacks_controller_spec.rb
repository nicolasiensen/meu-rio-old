require 'spec_helper'

describe OmniauthCallbacksController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:member]
  end
  describe "GET facebook" do
    subject{ get :facebook }
    it 'should call find_for_facebook_oauth' do
      controller.stub(:auth_data).and_return(FACEBOOK_VALID_AUTH_DATA) 
      ProviderAuthorization.should_receive(:find_for_facebook_oauth).with(FACEBOOK_VALID_AUTH_DATA, nil).and_return(Factory(:provider_authorization))
      subject
    end
    context "with wrong auth data" do
      before{ controller.stub(:auth_data).and_return(FACEBOOK_INVALID_AUTH_DATA) }
      it{ expect{subject}.to_not change{Member.count} }
      it{ expect{subject}.to_not change{ProviderAuthorization.count} }
      it{ should redirect_to(root_path) }
      it "should set a flash notice" do
        subject
        flash[:notice].should == 'You were unable to login'
      end
    end
    context "with right auth data" do
      before{ controller.stub(:auth_data).and_return(FACEBOOK_VALID_AUTH_DATA) }
      it{ expect{subject}.to change{Member.count}.by(1) }
      it{ expect{subject}.to change{ProviderAuthorization.count}.by(1) }
      it{ should redirect_to(root_path) }
      it "should set a flash notice" do
        subject
        flash[:notice].should == 'Welcome Diogo Biazus'
      end
    end
  end
end
