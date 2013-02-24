class Post < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  belongs_to :community
  belongs_to :user

  validates :text, presence: true
  validates :user, presence: true
  validates :community, presence: true

  scope :new_to_old, -> { order("created_at desc") }
end
