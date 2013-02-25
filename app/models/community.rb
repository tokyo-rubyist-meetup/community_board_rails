class Community < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  mount_uploader :photo, CommunityPhotoUploader
  belongs_to :owner, class_name: :User
  has_many :posts, :dependent => :destroy
  validates :name, presence: true
  validates :owner, presence: true
  validates :photo, presence: true

  def to_s
    name.to_s
  end
end
