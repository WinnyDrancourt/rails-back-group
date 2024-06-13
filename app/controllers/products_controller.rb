class ProductsController < ApplicationController
  include Rails.application.routes.url_helpers
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
    # Convertissez vos produits en JSON et ajoutez l'URL de l'image
    @products = @products.map do |product|
      product.as_json.merge({
        image_url: product.image.attached? ? url_for(product.image) : nil
      })
    end
  
    render json: @products
  end

  # GET /products/1
  def show
    if @product.image.attached?
      render json: @product.as_json.merge({
        image_url: rails_blob_url(@product.image, only_path: true)
      })
    else
      render json: @product.as_json(include: { user: { only: [:email] } })
    end
  end

  # POST /products
  def create
    @product = current_user.products.build(product_params)
    
    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  

  # DELETE /products/1
  def destroy
    @product.destroy!
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
end
