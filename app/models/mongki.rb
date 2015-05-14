require 'bcrypt'

# TODO : Terms for Muzmongki service

class Mongki
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include BCrypt

  attr_accessor :password, :password_confirmation

  field :email, type: String, default: nil
  field :name, type: String, default: nil
  field :password_encrypt, type: String, default: nil

  field :house, type: BSON::ObjectId, default: nil
  
  field :email_confirm, type: Boolean, default: false
  field :phone_confirm, type: Boolean, default: false
  field :email_confirm_text, type: String, default: nil
  field :phone_confirm_text, type: String, default: nil
  #field :terms, type: BSON::ObjectId

  # validate of email
  validates_presence_of :email, :message => "Address is REQUIRED!"
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, :message => "Address is INVALID!"
  validates_uniqueness_of :email, :message => "Address is already EXISTS!"

  # validate of id
  validates_presence_of :name, :message => "is REQUIRED!"
  validates_format_of :name, with: /[a-z0-9\-_]{3,15}/i, :message => "is INVALID!"
  validates_uniqueness_of :name, :message => "is already EXISTS!"
  #validates_exclusion_of :name, in: ProhibitedWord, :message => "contains Prohibited word!"

  # validate of password
  validates_length_of :password, minimum: 6, maximum: 15, :message => "should be 6 - 15 characters"
  validates_confirmation_of :password, :message => "is INCORRECT!"

  # validate of terms
  #validates_acceptance_of :terms, :allow_nil => false, :accept => true, :message => "TERMS_REQUIRED"

  before_save :encrypt_password

  def self.find_by_email(email)
    Mongki.find_by(email: email)
  end

  def self.find_by_name(name)
    Mongki.find_by(name: name)
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    password = Password.create(password)

    if user[:password_encrypt] == password
      true
    else
      false
    end
  end

  def self.authenticate(name, password)
    user = find_by_name(name)
    password = Password.create(password)

    if user[:password_encrypt] == password
      true
    else
      false
    end
  end

  protected
  # encrypt password
  def encrypt_password
    self.password_encrypt = Password.create(:password)
  end

end
