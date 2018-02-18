require "rails_helper"

RSpec.describe User, type: :model do
  describe "Association" do
    it { should have_many(:bucketlists) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password_digest) }
  end
end
