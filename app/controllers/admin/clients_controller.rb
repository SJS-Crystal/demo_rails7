class Admin::ClientsController < Admin::BaseController
  before_action :set_client, only: %i[ show edit update destroy ]

  def index
    @pagy, @clients = pagy(Client.all)
  end

  def show
  end

  def new
    @client = Client.new
  end

  def edit
  end

  def create
    @client = current_admin.clients.new(client_params)

    if @client.save
      redirect_to admin_clients_url, notice: "Client was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      redirect_to [:admin, @client], notice: "Client was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to admin_clients_url, notice: "Client was successfully destroyed.", status: :see_other
  end

  private

  def set_client
    @client = current_admin.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:username, :password, :password_confirmation, :name, :payout_rate, :balance)
  end
end
