class User < ActiveRecord::Base
  validates :name,      presence:   true
  validates :email,     presence:   true,
            uniqueness: true
  validates :password,  presence:   true,
            length:     { minimum: 6 },
            if:         lambda{ new_record? || !password.nil? }

  has_secure_password 

  has_many  :goals
  has_many  :notes
end
