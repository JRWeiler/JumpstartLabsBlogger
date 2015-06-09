class ArticlesController < ApplicationController
  include ArticlesHelper
  def index
    @articles = Article.all
    @article_months = Article.all.group_by{ |r| r.created_at.beginning_of_month }
    @articles_top_three = @articles.sort_by{ |r| r.view_count}.last(3).reverse!
  end
  
  def feed
    @articles = Article.all
    respond_to do |format|
      format.rss{render :layout => false}
    end
  end
  
  def show
    @article = Article.find(params[:id])
    @comment = Comment.new
    @comment.article_id = @article.id
    if @article.view_count
      @article.view_count += 1
    else
      @article.view_count = 1
    end
    @article.save
  end
  
  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(article_params)
    @article.save
    
    flash.notice = "Article '#{@article.title}' created!"
    
    redirect_to article_path(@article)
  end
  
  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    @article.update(article_params)
    
    flash.notice = "Article '#{@article.title}' Updated!"
    
    redirect_to article_path(@article)
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    
    flash.notice = "Article '#{@article.title}' Destroyed!"
    
    redirect_to articles_path
  end
  
  
  before_filter :require_login, only: [:new, :create, :edit, :update, :destroy]
  
end
