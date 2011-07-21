class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :member

  has_many :comment_flags

  validates_presence_of :content
  validates_presence_of :member_id
  validates_presence_of :commentable_id
  validates_presence_of :commentable_type

end