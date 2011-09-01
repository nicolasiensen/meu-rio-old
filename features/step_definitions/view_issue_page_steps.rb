Given /^(\d+) complete issues exist$/ do |count|
  count.to_i.times do
    issue = Factory.create(:issue)
    Factory.create(:debate, :issue => issue)
    Factory.create(:personal_story, :issue => issue)
    p = Factory.create(:complete_petition, :issue => issue)
    p.update_attributes({:state => 'published'})
  end
end


Then /^I should see the issue name$/ do
  page.should have_content "#{Issue.first.name}"
end



