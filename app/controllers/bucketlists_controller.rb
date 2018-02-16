class BucketlistsController < ApplicationController
  before_action :set_bucketlist, only: %i(show update destroy)

  def index
    @bucketlists = Bucketlist.all
    json_response(@bucketlists)
  end

  def create
    @bucketlist = Bucketlist.create!(bucketlist_params)
    json_response(@bucketlist, :created)
  end

  def show
    json_response(@bucketlist)
  end

  def update
    @bucketlist.update(bucketlist_params)
    head :no_content
  end

  def destroy
    @bucketlist.destroy
    head :no_content
  end

  private

  def bucketlist_params
    params.permit(:title, :created_by)
  end

  def set_bucketlist
    @bucketlist = Bucketlist.find(params[:id])
  end
end
