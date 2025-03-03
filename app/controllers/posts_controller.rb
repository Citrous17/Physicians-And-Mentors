class PostsController < ApplicationController
    before_action :require_login, only: [:new, :create]
  
    def new
      @post = Post.new
      @specialties = Specialty.all
    end
  
    def index
      @posts = Post.all.order(created_at: :desc) # Fetch all posts, newest first
    end    
  
    def create
      @post = Post.new(post_params)
      @post.sending_user_id = current_user.id  # Assign logged-in user's ID
  
      if @post.save
        if params[:post][:specialty_ids].present? # Account for if there are no specialties, for testing
            @post.specialty_ids = params[:post][:specialty_ids]
          end
        redirect_to posts_path, notice: "Post created successfully!"
      else
        @specialties = Specialty.all  # Reload specialties if there's an error
        render :new, status: :unprocessable_entity
      end
    end
  
    def show
      @post = Post.find_by(id: params[:id])
  
      if @post.nil?
        flash[:alert] = "Post not found"
        redirect_to posts_path
      end
    end
  
    private
  
    def post_params
      params.require(:post).permit(:title, :content, specialty_ids: []) # Removed :sending_user_id (we assign it)
    end

end
  
  
  
