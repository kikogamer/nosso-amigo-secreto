class PagesController < ApplicationController
  def home
    if user_signed_in?
      campaigns = current_user.campaigns

      if (campaigns.count > 0)
        redirect_to "/campaigns"
      end
    end
  end
end
