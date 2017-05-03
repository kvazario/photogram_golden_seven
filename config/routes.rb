Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # CREATE
  get("/photos/new", { :controller => "photos", :action => "new_form" })
  get("/create_photo", { :controller => "photos", :action => "create_row" })

  # READ
  get("/photos", { :controller => "photos", :action => "index" })
  get("/photos/:the_id", { :controller => "photos", :action => "show" })

  # UPDATE
  get("/photos/:la_id/edit", { :controller => "photos", :action => "edit_form" })
  get("/update_photo/:le_id", { :controller => "photos", :action => "update_row" })

  # DELETE
  get("/delete_photo/:da_id", { :controller => "photos", :action => "destroy_row" })
end
