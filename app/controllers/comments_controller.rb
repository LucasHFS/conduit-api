class CommentsController < ApplicationController
  before_action :find_article!
  before_action :authenticate_user!, only: %i[create destroy]

  def index
    @comments = @article
                .comments
                .limit(params[:limit] || 20)
                .offset(params[:offset] || 0)
                .order(created_at: :desc)
  end

  def create
    @comment = @article.comments.new(comment_params.merge(
                                       user: current_user
                                     ))

    if @comment.save
      render :show, status: :created
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @article.comments.find(params[:id])

    if user_is_comment_author?
      @comment.destroy

      render json: {}, status: :no_content
    else
      render json: { errors: { article: ['not owned by user'] } }, status: :forbidden
    end
  end

  private

  def user_is_comment_author?
    @current_user_id == @comment.user_id
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_article!
    @article = Article.find_by!(slug: params[:article_slug])
  end
end
