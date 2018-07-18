require 'rails_helper'

RSpec.describe CampaignRaffleJob, type: :job do

  describe "#perform_later" do
    it "raffle campaign" do
      expect {
        CampaignRaffleJob.perform_later
      }.to enqueue_job(CampaignRaffleJob)
    end
  end
end
