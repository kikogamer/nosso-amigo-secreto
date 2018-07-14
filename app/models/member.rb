class Member < ApplicationRecord
  belongs_to :campaign
  after_destroy :set_campaign_pending
  validates :name, :email, :campaign, presence: true
  validates_uniqueness_of :email, scope: :campaign_id, message: 'member already belongs to campaign'

  def set_pixel
    self.open = false
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Member.exists?(token: random_token)
    end
    self.save!
  end

  protected

  def set_campaign_pending
    self.campaign.update(status: :pending)
  end
end
