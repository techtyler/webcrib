class CribPlayer < ActiveRecord::Base
  has_secure_password validations:true
  validates_presence_of :username
  validates_presence_of :email
  validates_uniqueness_of :username

  #has_many games/stats
  #has_one active_game
end
