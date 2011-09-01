ActiveAdmin.register MeuRioTeamWidget do
  menu :parent => "Widgets", :label => "Meu Rio Team"
  filter :html_content

  index do
    column "HTML Content" do |w|
      raw w.html_content
    end
    column "Options" do |w|
      span link_to 'Show', admin_meu_rio_team_widget_path(w)
      span link_to 'Edit', edit_admin_meu_rio_team_widget_path(w)
    end
  end

  form :partial => "form"
  
end
