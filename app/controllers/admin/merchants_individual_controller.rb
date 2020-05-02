class Admin::MerchantsIndividualController < Admin::BaseController

  def update
    @merchant = Merchant.find(params[:id])
    @merchant.update(merchant_params)
    if @merchant.save
      flash[:success] = "Merchant has successfully been updated."
      redirect_to "/admin/merchants/#{@merchant.id}"
    else
      flash[:error] = "Unable to update merchant; #{@merchant.errors.full_messages.to_sentence}."
      redirect_to "/admin/merchants/#{@merchant.id}/edit"
    end
  end


  private

  def merchant_params
    params.permit(:name,:address,:city,:state,:zip)
  end
end
