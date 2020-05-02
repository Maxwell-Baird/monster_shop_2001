class Admin::MerchantItemsActiveController < Admin::BaseController


  def update
    @merchant = Merchant.find(params[:merchant_id])
    item = Item.find(params[:id])
    if item.status == true
      item.update(status: false)
      flash[:success] = "#{item.name} is no longer for sale."
    else
      item.update(status: true)
      flash[:success] = "#{item.name} is now for sale."
    end
    redirect_to "/admin/merchants/#{@merchant.id}/merchant_items"
  end

end
