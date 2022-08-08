class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: [:edit, :update, :destroy]
  def index
    @products = Product.all.includes(:vendor)
  end

  def new
    @product = Product.new
    @product.skus.build
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: '新增成功'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to edit_admin_product_path(@product), notice: '更新成功'
    else
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: '資料已刪除'
  end

  private

  def find_product
    @product = Product.friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :vendor_id, :sell_price, :list_price, :on_sell, :description, :cover_image, :category_id,
    skus_attributes: [:id, :spec, :quantity, :_destroy])
  end
end
