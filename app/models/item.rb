class Item < ApplicationRecord
  belongs_to :bucketlist

  validates_presence_of :name
end
