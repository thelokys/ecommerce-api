class SystemRequirement < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false }
  
  validates :storage    , presence: true
  validates :processor  , presence: true
  validates :memory     , presence: true
  validates :video_board, presence: true
  validates :operational_system, presence: true
  
  has_many :games, dependent: :restrict_with_error

end
