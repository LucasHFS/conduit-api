# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :find_article!, only: %i[show update destroy]

  def index
    @articles = Article.filter(filtering_params)
    @articles = @articles
                .order(created_at: :desc)
                .offset(params[:offset] || 0)
                .limit(params[:limit] || 20)

    @articles_count = @articles.size
  end

  def feed
    @articles = Article.includes(:user).where(user: current_user.following_users)

    @articles_count = @articles.size

    @articles = @articles
                .order(created_at: :desc)
                .offset(params[:offset] || 0)
                .limit(params[:limit] || 20)

    render :index
  end

  def show; end

  def create
    @article = Article.new(article_params)
    @article.user = current_user

    if @article.save
      render :show, status: :created
    else
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  def update
    if user_is_article_author?
      if @article.update(article_params)
        render :show
      else
        render json: { errors: @article.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: { article: ['not owned by user'] } }, status: :forbidden
    end
  end

  def destroy
    if user_is_article_author?
      @article.destroy

      render json: {}, status: :no_content
    else
      render json: { errors: { article: ['not owned by user'] } }, status: :forbidden
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, :body, tag_list: [])
  end

  def filtering_params
    params.slice(:author, :tag, :favorited)
  end

  def find_article!
    @article = Article.find_by!(slug: params[:slug])
  end

  def user_is_article_author?
    @current_user_id == @article.user_id
  end
end
