class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @products = Product.all.order(id: :desc).includes(:custom_fields)
    @pagy, @products = pagy(@products)
  end

  def show
  end

  def new
    @product = Product.new
    Settings.max_product_custom_field.times { @product.custom_fields.build }
  end

  def edit
    build_empty_custom_fields
  end

  def create
    @product = current_admin.products.new(product_params.merge currency: currency&.name)
    if @product.save
      redirect_to admin_products_url, notice: "Product was successfully created."
    else
      build_empty_custom_fields
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params.merge currency: currency&.name)
      redirect_to [:admin, @product], notice: "Product was successfully updated.", status: :see_other
    else
      build_empty_custom_fields
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_url, notice: "Product was successfully destroyed.", status: :see_other
  end

  private

  def build_empty_custom_fields
    remaining_fields_to_build = Settings.max_product_custom_field - @product.custom_fields.size
    remaining_fields_to_build.times { @product.custom_fields.build }
  end

  def set_product
    @product = current_admin.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :brand_id, :status, :price, :admin_id, :stock,
      custom_fields_attributes: [:id, :name, :value, :_destroy]
    )
  end

  def currency
    currency = Currency.find_by(id: params[:currency_id])
  end
end
