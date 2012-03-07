module UsersHelper

	# TODO: write functions to handle signing in

	def active_user	
		# Assumes our first user is anonymous
		@user ||= current_user
		@user ||= User.first
	end
	
	# Function uses the stuff in the info hash to find and login the user or create one if one doesn't exist
	# Keys that should be in the parameter hash
	# :email, :password, :name
	def api_find_or_create_user( info )
		# This code refused to cooperate so it's a bit inelegant
    # Sign_ins should be done on the controller level so are not handled here

    #Do a check for credicard info. If no present, find based on email, etc...

      #this finds user based on email, password, and user name
      unless User.find_by_email(info[:email]).nil?
        @user = User.find_by_email(info[:email])
        unless @user.valid_password?(info[:password])
          return nil
        end
        return @user
      else
        @user = User.create(:email => info[:email], :password => info[:password], :name => info[:name])
        return @user
      end

  end
end
