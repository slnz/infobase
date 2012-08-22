require 'spec_helper'

describe InfobaseUser do
	before(:each) do
		@person = Person.create!(:firstName => 'first')
		@user = @person.create_user(username: 'first.last@gmail.com')
		@user.person = @person
		@person.create_staff(accountNo: 123456)
	end
  
  describe "authentication" do
    describe "special" do
      before(:each) do 
        StaffsiteProfile.create!(userName: @user.username)
      end
      it "hr director" do
        @user.person.staff.jobTitle = "Director (HR)"
        @user.person.staff.save!
        info = InfobaseUser.determine_infobase_user(@user)
        info.class.should == InfobaseAdminUser
      end
      it "hr" do
        @person.staff.strategy = "HR"
        info = InfobaseUser.determine_infobase_user(@user)
        info.class.should == InfobaseHrUser
      end
      it "director" do
        @user.person.staff.jobTitle = "Director"
        info = InfobaseUser.determine_infobase_user(@user)
        info.class.should == InfobaseHrUser
      end
    end
    describe "normal" do
      it "StaffsiteProfile" do
        StaffsiteProfile.create!(userName: @user.username)
        info = InfobaseUser.determine_infobase_user(@user)
        info.class.should == InfobaseUser
      end    
      it "not removed from peopleSoft" do
        info = InfobaseUser.determine_infobase_user(@user)
        info.class.should == InfobaseUser
      end
      it "on team" do
        staff = @user.person.staff
        staff.update_attributes(removedFromPeopleSoft: "Y")
        info = InfobaseUser.determine_infobase_user(@user)
        info.should be(nil)
        
        team = Team.create!(name: 'team', region: 'region', country: 'usa', lane: 'lane')
        team_member = @person.team_members.create!(team: team)
        info = InfobaseUser.determine_infobase_user(@user)
        info.class.should == InfobaseUser
      end
    end
  end
end
