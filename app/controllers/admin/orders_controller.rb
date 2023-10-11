class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: %i[ show edit update ]
  before_action :can_edit_order?, only: %i[ edit update ]

  def index
    @pagy, @orders = pagy(Card.all.order(id: :desc).includes(:client, :product))
  end

  def show
  end

  def edit
  end

  def update
    unless ['rejected', 'issued'].include?(order_params[:status])
      flash[:danger] = 'Invalid status'
      return render :edit, status: :unprocessable_entity
    end

    if @order.update(order_params)
      redirect_to admin_order_url(@order), notice: "Success", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = current_admin.cards.find(params[:id])
  end

  def order_params
    params.require(:card).permit(:status)
  end

  def can_edit_order?
    return if @order.pending_approval?

    flash[:error] = 'Can only modifier pending approval orders'
    redirect_to admin_order_url(@order), status: :see_other
  end
end
