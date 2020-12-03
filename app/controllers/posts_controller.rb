class PostsController < ApplicationController
  before_action :authenticate_user!, only: :new

  def index  
  end

  def new 
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to root_path
    else
      render :new
    end  
  end

  private

  def post_params
    params.require(:post).permit(:title, :text, :country_id, :genre_id, :image).merge(user_id: current_user.id)  
  end  

end
