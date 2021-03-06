require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Admin' do
    it "I see the Admin links on the nav bar plus all other links, minus a cart link" do
      user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit '/'
      within 'nav' do
        expect(page).to have_link('Profile')
        expect(page).to have_link('Logout')
        expect(page).to have_link('Admin Dashboard')
        expect(page).to have_link('All Users')
        expect(page).to have_no_link('Merchant Dashboard')
        expect(page).to have_no_link('Log In')
        expect(page).to have_no_link('Register')
        expect(page).to have_no_link('Cart: 0')
        expect(page).to have_content("Logged in as: #{user.name}")
      end
    end

    it "404 errors when accessing cart" do
      admin = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit "/cart"

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    it "404 errors when accessing merchant paths" do
      admin = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit "/merchant"

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    it "I can click on the merchants name on the merchant index page, and I am taken to the admin/merchant show page" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      admin = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit 'admin/merchants'

      click_on "Brian's Bike Shop"

      expect(current_path).to eql("/admin/merchants/#{bike_shop.id}")

    end
  end
end
