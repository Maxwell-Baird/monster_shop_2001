class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def new
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params) && @item.valid?(:item_inventory)
      @item.default_photo?
      @item.save
      flash[:success] = "Item Succesfully Updated"
      redirect_to "/merchant/items"
    else
      flash[:error] = "#{@item.errors.full_messages.to_sentence}, try again."
      @item.restore_attributes
      render :edit
    end
  end

  def create
    @merchant = Merchant.find(current_user[:merchant_id])
    @item = @merchant.items.new(item_params)
    @item.default_photo?
    if @item.save
      flash[:success] = "#{@item.name} has been added to your catalog."
      redirect_to "/merchant/items"
    else
      flash[:error] = "Unable to add item: #{@item.errors.full_messages.to_sentence}."
      render :new
    end
  end

  def destroy
    item = Item.destroy(params[:id])
    flash[:success] = "#{item.name} has been removed from your inventory."
    redirect_to "/merchant/items"
  end

  private

  def item_params
    params[:image] = "https://www.thesun.co.uk/wp-content/uploads/2018/11/cat-2.png" unless params[:image] != ""
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end

end
