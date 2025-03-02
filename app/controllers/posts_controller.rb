class PostsController < ApplicationController
    def new
      @post = Post.new
    end
  
    def index
      @posts = Post.all.order(created_at: :desc) # Fetch all posts, newest first
    end    
  
    def create
      @post = Post.new(post_params)
      
      if @post.save
        redirect_to @post, notice: "Post created successfully!"
      else
        render :new, status: :unprocessable_entity
      end  # <-- This was missing
    end
  
    def show
      @post = Post.find_by(id: params[:id])
  
      if @post.nil?
        flash[:alert] = "Post not found"
        redirect_to posts_path
      end  # <-- This was missing
    end
  
    private
  
    def post_params
      params.require(:post).permit(:title, :content, :sending_user_id)
    end
  end
  
  
