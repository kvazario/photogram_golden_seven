class PhotosController < ApplicationController
  def index
    @List_of_all_my_photos = Photo.all
    render("photos/index.html.erb")
  end

  def show
    the_id= params[:the_id]
    @my_photo = Photo.find(the_id)
    render("photos/show.html.erb")
  end

  def new_form
    render("photos/new_form.html.erb")
  end

  def create_row
    url = params[:da_source]
    cap = params[:da_caption]
    new_photo = Photo.new
    new_photo.source = url
    new_photo.caption = cap
    new_photo.save
    redirect_to("/photos/#{new_photo.id}")
  end

  def edit_form
    new_photo = Photo.new
    new_photo.source = url
    new_photo.caption = cap
    new_photo.save
    redirect_to("/photos/#{new_photo.id}")
  end
end
