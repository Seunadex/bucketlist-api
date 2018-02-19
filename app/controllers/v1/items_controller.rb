module V1
  class ItemsController < ApplicationController
    before_action :set_bucketlist
    before_action :set_bucketlist_item, only: %i(show update destroy)

    def index
      if check_owner
        json_response({ message: "Unauthorized access", status: 403 })
      else
        json_response(@bucketlist.items)
      end
    end

    def show
      if check_owner
        json_response({ message: "Unauthorized access", status: 403 })
      else
        json_response(@item)
      end
    end

    def create
      @bucketlist.items.create!(item_params)
      json_response(@bucketlist, :created)
    end

    def update
      @item.update(item_params)
      head :no_content
    end

    def destroy
      if check_owner
        json_response({ message: "Unauthorized access", status: 403 })
      else
        @item.destroy
        json_response({
          message: "Successfully deleted you item"
        })
      end
    end

    def check_owner
      current_user.id != @bucketlist.created_by.to_i
    end


    private

    def item_params
      params.permit(:name)
    end

    def set_bucketlist
      @bucketlist = Bucketlist.find(params[:bucketlist_id]) 
    end

    def set_bucketlist_item
      @item = @bucketlist.items.find_by!(id: params[:id])if @bucketlist
    end
  end
end
