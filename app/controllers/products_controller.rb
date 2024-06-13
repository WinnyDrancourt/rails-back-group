class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show update destroy ]
  before_action :authenticate_user!, only: %i[ create update destroy ]
  before_action :authorize_user, only: %i[ update destroy ]

  # GET /products
  def index
    if params[:user_id]
      @products = Product.where(user_id: params[:user_id])
    else
      @products = Product.all
    end

    if params[:property_type]
      @products = @products.where(property_type: params[:property_type])
    end

    if params[:priceMax] && params[:priceMin]
      @products = @products.where('price BETWEEN ? AND ?', params[:priceMin], params[:priceMax])
    elsif params[:priceMax]
      @products = @products.where('price <= ?', params[:priceMax])
    elsif params[:priceMin]
      @products = @products.where('price >= ?', params[:priceMin])
    end
  
    if params[:areaMax] && params[:areaMin]
      @products = @products.where('area BETWEEN ? AND ?', params[:areaMin], params[:areaMax])
    elsif params[:areaMax]
      @products = @products.where('area <= ?', params[:areaMax])
    elsif params[:areaMin]
      @products = @products.where('area >= ?', params[:areaMin])
    end

    if params[:number_of_rooms]
      if params[:number_of_rooms].to_i >= 5
        @products = @products.where("number_of_rooms >= ?", params[:number_of_rooms])
      else
        @products = @products.where(number_of_rooms: params[:number_of_rooms])
      end
    end

    if params[:parking]
      @products = @products.where(parking: params[:parking])
    end
  
    if params[:city]
      @products = @products.where(city: params[:city])
    end

    if params[:_limit]
      limit = params[:_limit].to_i
      page = params[:page] ? params[:page].to_i : 1
      offset = (page - 1) * limit
  
      @products = @products.limit(limit).offset(offset)
    end

    @products = @products.map do |product|
      include_user_and_image_url(product)
    end

    render json: @products
  end

  # GET /products/1
  def show
    if @product
      product_json = include_user_and_image_url(@product)
      render json: product_json
    else
      render json: { error: "Product not found" }, status: :not_found
    end
  end

  # POST /products
  def create
    @product = current_user.products.build(product_params)
    # equivalent à :
    # @product = Product.new(product_params)
    # @product.user = current_user
    if params[:product][:image].present?
      @product.image.attach(params[:product][:image])
    end

    if @product.save
      render json: include_user_and_image_url(@product), status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      if params[:product][:image].present?
        @product.image.purge
        @product.image.attach(params[:product][:image])
      elsif @product.image.attached?
        @product.image.purge
      end
      render json: include_user_and_image_url(@product)
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    if @listing.destroy!
      render json: { message: "product has been deleted" }
    else
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def authorize_user
      if @product && @product.user_id != current_user.id
        render json: { error: "You are not authorized to perform this action" }, status: :unauthorized
      end
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(
        :title, 
        :price, 
        :description, 
        :user_id, 
        :property_type, 
        :category, 
        :pool, 
        :balcony, 
        :parking, 
        :garage, 
        :cellar, 
        :number_of_floors, 
        :elevator, 
        :disabled_access, 
        :energy_performance_diagnostic, 
        :area, 
        :number_of_rooms, 
        :furnished, 
        :terrace, 
        :garden, 
        :basement, 
        :caretaker, 
        :city,
        :image
      )
    end

    def include_user(product)
      product.as_json(include: { user: { only: [:email] } })
    end

    def include_image_url(product)
      product.as_json.merge(image_url: product.image.attached? ? url_for(product.image) : nil)
    end

    def include_user_and_image_url(product)
      product_json = include_user(product)
      product_json.merge(include_image_url(product))
    end
end
