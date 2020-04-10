require 'rails_helper'

RSpec.describe "As a registered user on the user profile orders page", type: :feature do
  it "I can see the orders info (id, date made, date updated, status, each item ordered(w/ name, desc, img, qty, price, subtotal), grandtotal and total_quantity)" do
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 1)
    order1 = user.orders.create(id: 3, name: "Colin", address: "400 Wash", city: "Denver", state: "CO", zip: 80203)
    order1.item_orders.create(order_id: order1.id, item: pull_toy, quantity: 2, price: pull_toy.price)
    order1.item_orders.create(order_id: order1.id, item: dog_bone, quantity: 7, price: dog_bone.price)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/profile/orders/"
    click_on "#{order1.id}"
    expect(current_path).to eql("/profile/orders/#{order1.id}")

    within '.shipping-address' do
      expect(page).to have_content(order1.name)
      expect(page).to have_content(order1.address)
      expect(page).to have_content(order1.city)
      expect(page).to have_content(order1.state)
      expect(page).to have_content(order1.zip)
    end

    within "#item-#{pull_toy.id}" do
      expect(page).to have_link(pull_toy.name)
      expect(page).to have_link("#{pull_toy.merchant.name}")
      expect(page).to have_content("$#{pull_toy.price}")
      expect(page).to have_content("2")
      expect(page).to have_content("$20")
    end

    within "#item-#{dog_bone.id}" do
      expect(page).to have_link(dog_bone.name)
      expect(page).to have_link("#{dog_bone.merchant.name}")
      expect(page).to have_content("$#{dog_bone.price}")
      expect(page).to have_content("7")
      expect(page).to have_content("$147")
    end

    within "#grandtotal" do
      expect(page).to have_content("Total Cost: $167")
    end
    within "#total_quantity" do
      expect(page).to have_content("Total Items: 9")
    end

    within "#timestamps" do
      expect(page).to have_content(order1.created_at)
      expect(page).to have_content(order1.updated_at)
    end

    within "#order-id" do
      expect(page).to have_content("Order ID: #{order1.id}")
    end
  end
end
