class CampaignMailer < ApplicationMailer

  def raffle(campaign, member, friend)
    @campaign = campaign
    @member = member
    @friend = friend
    mail to: @member.email, subject: "Nosso Amigo Secreto: #{@campaign.title}"
  end

  def raffle_error(campaign)
    @campaign = campaign
    mail to: @campaign.user.email, subject: "Problemas com o sorteio da campanha: #{@campaign.title}"
  end
end
