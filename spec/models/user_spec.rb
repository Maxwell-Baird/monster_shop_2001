require 'rails_helper'

describe User do
  describe "validations" do
    [:name, :address, :city, :state, :zip, :address, :password].each do |field|
      it { should validate_presence_of field }

    end
  end

  describe "relationships" do
    it {should have_many :orders}
    it {should belong_to :merchants}
  end
end
