class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def new
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def create
    @merchant = Merchant.find(current_user[:merchant_id])
    discount = @merchant.discounts.new(discount_params)
    if discount.save
      flash[:success] = "A new discount has created."
      redirect_to "/merchant/discounts"
    else
      flash[:error] = "Unable to create discount: #{discount.errors.full_messages.to_sentence}."
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    if @discount.save
      redirect_to "/merchant/discounts"
    else
      flash[:error] = "Unable to update discount: #{@discount.errors.full_messages.to_sentence}."
      render :edit
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to "/merchant/discounts"
  end

  private

  def discount_params
    params.permit(:percent,:amount)
  end
end
