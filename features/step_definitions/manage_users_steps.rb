Given /^there are (\d+) admin users$/ do |count|
  count.to_i.times do
    Factory.create(:user)
  end 
end

When /^I fill out the new User form$/ do
  fill_in "user_first_name", :with => "Nicolas"
  fill_in "user_last_name", :with => "Iensen"
  fill_in "user_email", :with => "johnson@denmark.de"
  fill_in "user_password", :with => "no_one_will_guess_this"
  fill_in "user_password_confirmation", :with => "no_one_will_guess_this"
end

When /^I fill in the edit user form$/ do
  fill_in "user_first_name", :with => "Harold"
  fill_in "user_last_name", :with => "Kerzner"
  fill_in "user_email", :with => "projectmanager@kerzner.com"
  fill_in "user_password", :with => "no_one_will_guess_this"
  fill_in "user_password_confirmation", :with => "no_one_will_guess_this"
end

When /^I fill in the edit user form without the password field$/ do
  fill_in "user_first_name", :with => "Harold"
  fill_in "user_last_name", :with => "Kerzner"
  fill_in "user_email", :with => "projectmanager@kerzner.com"
end

Then /^I should see a list of administrative users$/ do
  page.has_content? User.first.first_name
  page.has_content? User.last.first_name
end

Then /^I should see a new User form$/ do
  page.has_content? "Add a new user"
  page.has_content? "form#new_user"
end

Then /^I should see an edit User form$/ do
  page.has_content? "Edit User"
  page.has_content? "form#edit_user"
end
