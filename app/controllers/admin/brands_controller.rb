class Admin::BrandsController < Admin::BaseController
  before_action :set_brand, only: %i[show edit update destroy]

  def index
    @brands = current_admin.brands.order(id: :desc).includes(:custom_fields)
    @pagy, @brands = pagy(@brands)
  end

  def show
  end

  def new
    @brand = current_admin.brands.build
    Settings.max_brand_custom_field.times { @brand.custom_fields.build }
  end

  def edit
    build_empty_custom_fields
  end

  def create
    @brand = current_admin.brands.new(brand_params)

    if @brand.save
      redirect_to admin_brands_url, notice: 'Brand was successfully created.'
    else
      build_empty_custom_fields
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @brand.update(brand_params)
      redirect_to [:admin, @brand], notice: 'Brand was successfully updated.', status: :see_other
    else
      build_empty_custom_fields
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @brand.destroy
    redirect_to admin_brands_url, notice: 'Brand was successfully destroyed.', status: :see_other
  end

  private

  def build_empty_custom_fields
    remaining_fields_to_build = Settings.max_brand_custom_field - @brand.custom_fields.size
    remaining_fields_to_build.times { @brand.custom_fields.build }
  end

  def set_brand
    @brand = current_admin.brands.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(:name, :status, :admin_id,
      custom_fields_attributes: [:id, :name, :value, :_destroy])
  end
end
