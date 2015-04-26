class User < ActiveRecord::Base
  has_many :images

  has_secure_password validations: false  # use the validatons below

  # very simple email matcher ~ "includes an @ and a . and some charachters around them"
  # real email validation will happen over activation email
  validates :email, presence: true, uniqueness: true, format: /\S+@\S+\.\S+/
  validates :name, length: { minimum: 3 }
  validates :password, length: { minimum: 4 }, on: :create
  validates :password, confirmation: true

  def confirmed?
    confirmed
  end

  def confirm!
    update(confirmed: valid?)
  end
end
