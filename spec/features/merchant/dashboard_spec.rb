require 'rails_helper'

RSpec.describe 'As a merchant user on the merchant dashboard page', type: :feature do
  it "I see the name and full address of the merchant I am associated with" do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    merchant_user = @bike_shop.users.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

    visit "/merchant"

    within '.merchant-info' do
      expect(page).to have_content(@bike_shop.name)
      expect(page).to have_content(@bike_shop.address)
      expect(page).to have_content(@bike_shop.city)
      expect(page).to have_content(@bike_shop.state)
      expect(page).to have_content(@bike_shop.zip)
    end
  end
end
