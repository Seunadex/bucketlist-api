module V1
  class BucketlistsController < ApplicationController
    before_action :set_bucketlist, only: %i(show update destroy)

    def index
      @bucketlists = current_user.bucketlists
      json_response(@bucketlists)
      if current_user.id != @bucketlists[0].created_by.to_i
        "Unauthorized"
      end
    end

    def create
      @bucketlist = current_user.bucketlists.create!(bucketlist_params)
      json_response(@bucketlist, :created)
    end

    def show
      if check_owner
        json_response({ message: "Unauthorized access", status: 403 })
      else
        json_response(@bucketlist)
      end
    end

    def update
      if check_owner
        json_response({
          message: "Oops Sorry You can not edit this bucketlist",
          status: 403
        })
      else
        @bucketlist.update(bucketlist_params)
        json_response(
          message: "Updated",
          bucketlist: @bucketlist
        )
      end
    end

    def destroy
      if check_owner
        json_response({
          message: "What do you think you want to do? nah cmon!!"
        })
      else
        @bucketlist.destroy
        json_response({
          message: "Successfully deleted you bucketlist"
        })
      end
    end

    def check_owner
      current_user.id != @bucketlist.created_by.to_i
    end

    private

    def bucketlist_params
      params.permit(:title, :created_by)
    end

    def set_bucketlist
      @bucketlist = Bucketlist.find(params[:id])
    end
  end
end
