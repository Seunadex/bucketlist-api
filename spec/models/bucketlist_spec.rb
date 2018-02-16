require "rails_helper"

RSpec.describe Bucketlist, type: :model do
  context "Associations" do
    it { should have_many(:items).dependent(:destroy) }
  end

  context "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:created_by) }
  end
end
