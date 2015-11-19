class OrdersController < ApplicationController
	before_action :set_order, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!
	
	def index
    @orders = Order.all		
	end
	
	def show
	end
	
	def new
    @order = Order.new
    @listing = Listing.find(params[:listing_id])		
	end
	
	def edit
	end
	
	def create
    @order = Order.new(order_params)
    @listing = Listing.find(params[:listing_id])
    @seller = @listing.user
    
    @order.listing_id = @listing.id
    @order.buyer_id   = current_user.id
    @order.seller_id  = @seller.id
    
    if @order.save
	    redirect_to root_url, notice: "Order was successfully created."
	  else
	    render :new
	  end		
	end
	
	def update
		if @order.update(order_params)
			redirect_to @order, notice: 'Order was successfully updated.' 
		else
		  render :edit
		end
	end
	
	def destroy
		@order.destroy
		redirect_to orders_url, notice: 'Order was deleted.'
	end
	
	private	
  
    def set_order
	    @order = Order.find(params[:id])
	  end
	  
	  def order_params
		  params.require(:order).permit(:address, :city, :state)
		end
end