class Bucketlist < ApplicationRecord
  has_many :items, dependent: :destroy

  validates_presence_of :name, :created_by
end
