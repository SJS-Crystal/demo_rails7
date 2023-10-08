class Admin::BrandsController < Admin::BaseController
  before_action :set_admin_brand, only: %i[ show edit update destroy ]

  # GET /admin/brands
  def index
    @brands = Brand.all
  end

  # GET /admin/brands/1
  def show
  end

  # GET /admin/brands/new
  def new
    @brand = Brand.new
  end

  # GET /admin/brands/1/edit
  def edit
  end

  # POST /admin/brands
  def create
    @brand = Brand.new(admin_brand_params)

    if @brand.save
      redirect_to admin_brands_url, notice: "Brand was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/brands/1
  def update
    if @brand.update(admin_brand_params)
      redirect_to [:admin, @brand], notice: "Brand was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/brands/1
  def destroy
    @brand.destroy
    redirect_to admin_brands_url, notice: "Brand was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_brand
      @brand = Brand.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_brand_params
      params.require(:brand).permit(:name)
    end
end
