class Admin::MerchantItemsController < Admin::BaseController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
    if @item.update(item_params)
      @item.save
      flash[:success] = "Item Succesfully Updated"
      redirect_to "/admin/merchants/#{@merchant.id}/merchant_items"
    else
      flash[:error] = "Incorrectly filled out #{@item.changed_attributes.keys.join(", ")}, try again."
      @item.restore_attributes
      render :edit
    end
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = @merchant.items.new(item_params)
    if item.save
      flash[:success] = "#{item.name} has been added to your catalog."
      redirect_to "/admin/merchants/#{@merchant.id}/merchant_items"
    else
      flash[:success] = "Unable to add item: #{item.errors.full_messages.to_sentence}."
      render :new
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    item = Item.destroy(params[:id])
    flash[:success] = "#{item.name} has been removed from your inventory."
    redirect_to "/admin/merchants/#{merchant.id}/merchant_items"
  end

  private

  def item_params
    params[:image] = "https://www.thesun.co.uk/wp-content/uploads/2018/11/cat-2.png" unless params[:image] != ""
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
