class Admin::BrandsController < Admin::BaseController
  before_action :set_admin_brand, only: %i[ show edit update destroy ]

  # GET /admin/brands
  def index
    @admin_brands = Admin::Brand.all
  end

  # GET /admin/brands/1
  def show
  end

  # GET /admin/brands/new
  def new
    @admin_brand = Admin::Brand.new
  end

  # GET /admin/brands/1/edit
  def edit
  end

  # POST /admin/brands
  def create
    @admin_brand = Admin::Brand.new(admin_brand_params)

    if @admin_brand.save
      flash[:success] = "Brand was successfully created."
      redirect_to @admin_brand
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/brands/1
  def update
    if @admin_brand.update(admin_brand_params)
      flash[:success] = "Brand was successfully updated."
      redirect_to @admin_brand, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/brands/1
  def destroy
    @admin_brand.destroy
    flash[:success] = "Brand was successfully destroyed."
    redirect_to admin_brands_url, status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_brand
      @admin_brand = Admin::Brand.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_brand_params
      params.require(:admin_brand).permit(:name)
    end
end
