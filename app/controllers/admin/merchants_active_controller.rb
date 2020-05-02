class Admin::MerchantsActiveController < Admin::BaseController

  def update
    merchant = Merchant.find(params[:id])
    if merchant.status == true
      merchant.status = false
      merchant.items_status(false)
      flash[:success] = "#{merchant.name} is now disabled."
    else
      merchant.status = true
      merchant.items_status(true)
      flash[:success] = "#{merchant.name} is now enabled."
    end
    merchant.save
    redirect_to '/admin/merchants'
  end

end
