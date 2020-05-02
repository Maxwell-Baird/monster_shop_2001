class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:id])
  end

  def index
    @merchants = Merchant.all
  end

  def new
  end

  def create
    merchant = Merchant.create(merchant_params)
    if merchant.save
      flash[:success] = "#{merchant.name} was successfully created."
      redirect_to "/admin/merchants"
    else
      flash[:error] = "Unable to create merchant; #{merchant.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    order = Order.find (params[:id])
    order.status = "Shipped"
    order.save
    redirect_to '/admin'
  end


  def destroy
    merchant = Merchant.find(params[:id])
    merchant.destroy
    flash[:success] = "Successfully deleted #{merchant.name}"
    redirect_to '/admin/merchants'
  end

  private

  def merchant_params
    params.permit(:name,:address,:city,:state,:zip)
  end
end
