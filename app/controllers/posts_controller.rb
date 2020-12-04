class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]

  def index  
    @posts = Post.includes(:user).order("created_at DESC")
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

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])    
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(params[:id])
    else
      render :edit    
    end
  end
  
  private

  def post_params
    params.require(:post).permit(:title, :text, :country_id, :genre_id, :image).merge(user_id: current_user.id)  
  end  

end
