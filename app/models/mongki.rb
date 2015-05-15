require 'bcrypt'
require 'digest/sha2'

# TODO : Terms for Muzmongki service

class Mongki
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include BCrypt

  attr_accessor :password, :password_confirmation

  field :email, type: String, default: nil
  field :name, type: String, default: nil
  field :password_encrypt, type: String, default: nil

  field :token, type: String, default: nil

  field :house, type: BSON::ObjectId, default: nil
  
  field :email_confirm, type: Boolean, default: false
  field :phone_confirm, type: Boolean, default: false
  field :email_confirm_text, type: String, default: nil
  field :phone_confirm_text, type: String, default: nil
  #field :terms, type: BSON::ObjectId

  before_create :create_token
  before_validation :downcase_field
  before_save :encrypt_password

  # validate of email
  validates_presence_of :email, :message => "Address is REQUIRED!"
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, :message => "Address is INVALID!"
  validates_uniqueness_of :email, :case_sensitive => false, :message => "Address is already EXISTS!"

  # validate of name
  validates_presence_of :name, :message => "is REQUIRED!"
  validates_format_of :name, with: /[a-z0-9\-_]{3,15}/i, :message => "is INVALID!"
  validates_uniqueness_of :name, :case_sensitive => false, :message => "is already EXISTS!"
  #validates_exclusion_of :name, in: ProhibitedWord, :message => "contains Prohibited word!"

  # validate of password
  validates_length_of :password, minimum: 6, maximum: 15, :message => "should be 6 - 15 characters"
  validates_confirmation_of :password, :message => "is INCORRECT!"

  # validate of terms
  #validates_acceptance_of :terms, :allow_nil => false, :accept => true, :message => "TERMS_REQUIRED"

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt_token(token)
    Digest::SHA2.hexdigest(token.to_s)
  end

  def authenticate(password)
    password = BCrypt::Engine.hash_secret(password, $mongki_salt)

    if (password == self.password_encrypt)
      true
    else
      false
    end
  end

  private

  def create_token
    self.token= Mongki.encrypt_token(Mongki.new_token)
  end

  def encrypt_password
    self.password_encrypt= BCrypt::Engine.hash_secret(password, $mongki_salt)
  end

  def downcase_field
    self.email= self.email.downcase
  end

end
