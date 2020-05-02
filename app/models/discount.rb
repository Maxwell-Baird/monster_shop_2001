class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percent, :amount

  validates_inclusion_of :percent, in: 1..99
end
