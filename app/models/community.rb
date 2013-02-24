class Community < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  belongs_to :owner, class_name: :User
  validates :name, presence: true
  validates :owner, presence: true

  def to_s
    name.to_s
  end
end
