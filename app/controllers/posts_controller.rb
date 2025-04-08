class PostsController < ApplicationController
    before_action :require_login

    def new
      @post = Post.new
      @specialties = Specialty.all
    end

    def index
      @specialties = Specialty.all # Regular users can filter by any specialty
        if params[:specialty_id].present?
          @posts = Post.joins(:specialties)
                       .where(specialties: { id: params[:specialty_id] })
                       .distinct
        else
          @posts = Post.all
        end
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
      @post = Post.find(params[:id])
      @comment = @post.comments.build
      @comments = @post.comments.order(created_at: :asc)
      # Check if the user is a professional and has matching specialties
      if current_user.isProfessional?
        user_specialty_ids = current_user.specialties.pluck(:id)
        unless @post.specialties.where(id: user_specialty_ids).exists?
          redirect_to posts_path, alert: "You are not authorized to view this post."
        end
      end
    end

    def create_comment
      @post = Post.find(params[:id])
      @comment = @post.comments.build
      @comment.sending_user_id = current_user.id
      @comment.parent_post_id = @post.id # Set the parent post ID for the comment
      @comment.content = params[:comment][:content] if params[:comment].present?
      @comment.sending_user_id = current_user.id
      @comment.parent_post_id = @post.id # Set the parent post ID for the comment

      if @comment.save
        redirect_to post_path(@post), notice: "Comment created successfully!"
      else
        @comments = @post.comments.order(created_at: :asc)
        render :show, status: :unprocessable_entity
      end
    end
  
    private

    def post_params
      params.require(:post).permit(:title, :content, :sending_user_id, specialty_ids: []) # Removed :sending_user_id (we assign it)
    end

end
