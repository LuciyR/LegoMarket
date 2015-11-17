class ListingsController < ApplicationController
	before_action :set_listing, only: [:show, :edit, :update, :destroy]
	before_filter :authenticate_user!, only: [:seller, :new, :create, :edit, :update, :destroy]
	before_filter :check_user, only: [:edit, :update, :destroy]
	
	def seller
    @listings = Listing.where(user: current_user).order("created_at DESC")		
	end
	
	def index
	  @listings = Listing.all.order("created_at DESC")
	end
	
	def show;  end
	
	def new
    @listing = Listing.new		
	end
	
	def create
		@listing = Listing.new(listing_params)
		@listing.user_id = current_user.id
		if @listing.save
			redirect_to @listing, notice: 'Listing was successfully created.'
		else
		  render :new
		end
	end
	
	def update
		if @listing.update(listing_params)
			redirect_to @listing, notice: 'Listing was successfully updated.' 
		else
		  render :edit
		end
	end
	
	def destroy
		@listing.destroy
		redirect_to listings_url, notice: 'Listing was deleted.'
	end
  
  private	
  
    def set_listing
	    @listing = Listing.find(params[:id])
	  end
	  
	  def listing_params
		  params.require(:listing).permit(:name, :description, :price, :image)
		end
		
		def check_user
      if current_user != @listing.user
	      redirect_to root_url, alert: "Sorry, this listing belongs to someone else"
	    end
		end
end