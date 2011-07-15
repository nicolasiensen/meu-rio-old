class PetitionSignature < ActiveRecord::Base
  belongs_to :petition
  belongs_to :member

  after_create :send_confirmation
  validate :belongs_to_published_petition

  def send_confirmation
    PetitionMailer.petition_signature_confirmation(self).deliver
  end

  def belongs_to_published_petition
    errors.add(:petition, "Petition must be published in order to be signed") unless petition.published?
  end

  def reject_comment
    self.update_attribute :comment_accepted, false
    self
  end

  def accept_comment
    self.update_attribute :comment_accepted, true
    self
  end
end
