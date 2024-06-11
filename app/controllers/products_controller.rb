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

    if params[:_limit]
      limit = params[:_limit].to_i
      page = params[:page] ? params[:page].to_i : 1
      offset = (page - 1) * limit
  
      @products = @products.limit(limit).offset(offset)
    end

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product.as_json(include: { user: { only: [:email] } })
  end

  # POST /products
  def create
    @product = current_user.products.build(product_params)
    if params[:image].present?
      @product.image.attach(params[:image])
    end

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
        :city
      )
    end
end
