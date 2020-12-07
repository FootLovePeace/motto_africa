class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]
  before_action :set_post, only: [:show, :edit, :update]
  before_action :move_to_index, except: [:index, :show, :new, :create, :destroy]

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
    @comment = Comment.new
    @comments = @post.comments.includes(:user)
  end

  def edit    
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(params[:id])
    else
      render :edit    
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to root_path
  end
  
  private

  def post_params
    params.require(:post).permit(:title, :text, :country_id, :genre_id, :image).merge(user_id: current_user.id)  
  end  

  def set_post
    @post = Post.find(params[:id])
  end

  def move_to_index
    unless user_signed_in? && current_user.id == @post.user_id
      redirect_to action: :index
    end
  end

end
