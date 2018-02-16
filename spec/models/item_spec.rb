require "rails_helper"

RSpec.describe Item, type: :model do
  context "Associations" do
    it { should belong_to(:bucketlist) }
  end

  context "Validations" do
    it { should validate_presence_of(:name) }
  end
end
