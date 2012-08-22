require 'spec_helper'

describe InfobaseUser do
	before(:each) do
		@person = Person.create!(:firstName => 'first')
		@user = @person.create_user(username: 'first.last@gmail.com')
		@user.person = @person
		@person.create_staff(accountNo: 123456)
	end
  describe "auth" do
  	it "via StaffsiteProfile" do
	  	StaffsiteProfile.create!(userName: @user.username)
	  	info = InfobaseUser.determine_infobase_user(@user, nil)
  	end
  end

  xit "auth - hr or admin" do
  end

  xit "auth - if person not removed from peopleSoft" do
  end

  xit "auth - person on team" do
  end
end
