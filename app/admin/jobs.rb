ActiveAdmin.register Job do
  menu :priority => 11
  index do
    column :title
    column :active
    column "Options" do |j|
      span link_to 'Show', admin_job_path(j)
      span link_to 'Edit', edit_admin_job_path(j)
      span link_to 'Delete', admin_job_path(j), :confirm => 'Are you sure?', :method => :delete
    end
  end

  form do |f|
    f.inputs "Job" do
      f.input :title, :as => :string
      f.input :description
      f.input :active
    end

    f.buttons
  end
end
