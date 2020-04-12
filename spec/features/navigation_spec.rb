
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Cart: 0'
      end

      expect(current_path).to eq('/cart')

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/')

      within 'nav' do
        click_link 'Log-In'
      end

      expect(current_path).to eq('/login')

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')

    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end

    it "404 errors when trying to access paths /merchants or /admin" do
      visitor = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(visitor)

      visit "/merchant"

      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit "/admin"

      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit "/profile"

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
