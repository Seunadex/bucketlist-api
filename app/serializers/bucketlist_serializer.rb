class BucketlistSerializer < ActiveModel::Serializer
  attributes :id, :title, :updated_at, :created_by, :created_at

  has_many :items
end
