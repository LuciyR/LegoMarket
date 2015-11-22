class ListingsController < ApplicationController
	before_action :set_listing, only: [:show, :edit, :update, :destroy]
	before_filter :authenticate_user!, only: [:seller, :new, :create, :edit, :update, :destroy]
	before_filter :check_user, only: [:edit, :update, :destroy]
	
	def seller
    @listings = Listing.where(user: current_user).order("created_at DESC")		
	end
	
	def index
		if params[:category].blank?
	    @listings = Listing.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 12)
	  else
      @category_id = Category.find_by(name: params[:category]).id
      @listings = Listing.where(category_id: @category_id).order("created_at DESC")	  
	  end
	end
	
	def show;  end
	
	def new
    @listing = Listing.new		
	end
	
	def create
		@listing = Listing.new(listing_params)
		@listing.user_id = current_user.id
		
		if current_user.recipient.blank?
			Stripe.api_key = ENV["STRIPE_API_KEY"]
	    token = params[:stripeToken]
	    
	    recipient = Stripe::Recipient.create(
		    :name         => current_user.name,
		    :type         => "individual",
		    :bank_account => token
	    )
	  end
    
    current_user.recipient = recipient.id
    current_user.save
    
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
		  params.require(:listing).permit(:name, :category_id, :description, :price, :image)
		end
		
		def check_user
      if current_user != @listing.user
	      redirect_to root_url, alert: "Sorry, this listing belongs to someone else"
	    end
		end
end