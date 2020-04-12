class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :email

  belongs_to :merchant
  has_many :orders

  has_secure_password
end
