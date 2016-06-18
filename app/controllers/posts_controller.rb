class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :validate_user, only: [:create, :update, :destroy]
  before_action :validate_type, only: [:create, :update]

  def index
    posts = Post.all
    if params[:filter]
      posts = posts.where(["category = ?", params[:filter]])
    end
    if params['sort']
      f = params['sort'].split(',').first
      field = f[0] == '-' ? f[1..-1] : f
      order = f[0] == '-' ? 'DESC' : 'ASC'
      if Post.new.has_attribute?(field)
        posts = posts.order("#{field} #{order}")
      end
    end
    posts = posts.page(params[:page] ? params[:page][:number] : 1)
    render json: posts, meta: pagination_meta(posts).merge(default_meta), include: ['user']
  end

  def show
    render json: @post, meta: default_meta
  end

  def create
    post = Post.new(post_params)
    if post.save
      render json: post, status: :created, meta: default_meta
    else
      render_error(post, :unprocessable_entity)
    end
  end

  def update
    if @post.update_attributes(post_params)
      render json: @post, status: :ok, meta: default_meta
    else
      render_error(@post, :unprocessable_entity)
    end
  end

  def destroy
    @post.destroy
    head 204
  end

  private
  def set_post
    begin
      @post = Post.find params[:id]
    rescue ActiveRecord::RecordNotFound
      post = Post.new
      post.errors.add(:id, "Wrong ID provided")
      render_error(post, 404) and return
    end
  end

  def post_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
