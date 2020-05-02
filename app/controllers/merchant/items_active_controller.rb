class Merchant::ItemsActiveController < Merchant::BaseController


  def update
    item = Item.find(params[:id])
    if item.status == true
      item.update(status: false)
      flash[:success] = "#{item.name} is no longer for sale."
    else
      item.update(status: true)
      flash[:success] = "#{item.name} is now for sale."
    end
      redirect_to "/merchant/items"
  end

end
