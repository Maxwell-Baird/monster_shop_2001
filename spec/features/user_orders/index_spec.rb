require 'rails_helper'

RSpec.describe "As a registered user on the user profile orders page", type: :feature do
  it "I can see every order this user has made with order id, date made, date updated, status, qty of items in order and total amount for order" do
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 1)
    order1 = user.orders.create(id: 3, name: "Colin", address: "400 Wash", city: "Denver", state: "CO", zip: 80203)
    order1.item_orders.create(order_id: order1.id, item: pull_toy, quantity: 1, price: pull_toy.price)
    order2 = user.orders.create(id: 14, name: "Colin", address: "400 Wash", city: "Denver", state: "CO", zip: 80203)
    order2.item_orders.create(order_id: order2.id, item: dog_bone, quantity: 2, price: dog_bone.price)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit '/profile/orders'

    within(".orders-index") do
      within("#order-#{order1.id}") do
        expect(page).to have_link(order1.id)
        expect(page).to have_content(order1.created_at)
        expect(page).to have_content(order1.updated_at)
        expect(page).to have_content(order1.status)
        expect(page).to have_content(order1.total_quantity)
        expect(page).to have_content(order1.grandtotal)
      end
      within("#order-#{order2.id}") do
        expect(page).to have_link(order2.id)
        expect(page).to have_content(order2.created_at)
        expect(page).to have_content(order2.updated_at)
        expect(page).to have_content(order2.status)
        expect(page).to have_content(order2.total_quantity)
        expect(page).to have_content(order2.grandtotal)
      end
    end
  end

  it "I can click on an order id and I am taking to that profile order show page" do
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 1)
    order1 = user.orders.create(id: 3, name: "Colin", address: "400 Wash", city: "Denver", state: "CO", zip: 80203)
    order1.item_orders.create(order_id: order1.id, item: pull_toy, quantity: 1, price: pull_toy.price)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/profile/orders"

    click_link "#{order1.id}"

    expect(current_path).to eql("/profile/orders/#{order1.id}")
  end
end
