Given /^I have logged in previously through Facebook$/ do
  Factory.create(:provider_authorization)
end

Given /^I am a member with a MR login$/ do
  m = Factory.create(:member)
  m.update_attributes(:password => "clever_password", :password_confirmation => "clever_password")
end

When /^I fill in the new member form$/ do
  fill_in "member_first_name", :with => "John"
  fill_in "member_last_name", :with => "Smith"
  fill_in "member_email", :with => "john@example.com"
  fill_in "member_password", :with => "wordpass"
  fill_in "member_password_confirmation", :with => "wordpass"
end

When /^I fill in the new member form with the same email$/ do
  fill_in "member_first_name", :with => "#{Member.first.first_name}"
  fill_in "member_last_name", :with => "#{Member.first.last_name}"
  fill_in "member_email", :with => "#{Member.first.email}"
  fill_in "member_password", :with => "wordpass"
  fill_in "member_password_confirmation", :with => "wordpass"
end

When /^I fill out the member login form$/ do
  fill_in "member_email", :with => "#{Member.first.email}"
  fill_in "member_password", :with => "clever_password"
end

Then /^I should see a new member form$/ do
  page.should have_css("form#member_new")
  page.should have_css("#member_first_name")
end

Then /^I should see a member login form$/ do
  page.should have_css("form#member_new")
  page.should_not have_css("#member_first_name")
end

Then /^I should see the homepage$/ do
  page.should have_content('De Olho No Legislativo')
  page.should have_content('Quer nos')
  page.should have_content('Ajudar a construir')
  page.should have_content('Rio Mais Justo?')
end

