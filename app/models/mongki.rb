require 'bcrypt'

class Mongki
  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt

  attr_accessor :password, :password_confirmation

  field :email, type: String
  field :name, type: String
  field :phone, type: String, default: nil
  field :password_encrypt, type: String

  field :house, type: BSON::ObjectId, default: nil
  
  field :email_confirm, type: Boolean, default: false
  field :phone_confirm, type: Boolean, default: false
  field :email_confirm_text, type: String, default: nil
  field :phone_confirm_text, type: String, default: nil
  #field :terms, type: Boolean, default: false

  # validate of email
  validates_presence_of :email, :message => "EMAIL_REQUIRED"
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, :message => "EMAIL_INVALID"
  validates_uniqueness_of :email, :message => "EMAIL_EXISTS"

  # validate of name
  validates_presence_of :name, :message => "NAME_REQUIRED"
  validates_format_of :name, with: /[a-z0-9\-_]{3, 15}/i, :message => "NAME_INVAILD"
  validates_uniqueness_of :name, :message => "NAME_EXISTS"

  # validate of phone
  validates_format_of :phone, with: /\+\d{2,3}((\s|\-)(\d{2,5})){2,4}/, :message => "PHONE_INVALID"
  validates_uniqueness_of :phone, :message => "PHONE_EXISTS"

  # validate of password
  validates_length_of :password, minimum: 6, maximum: 15, :message => "PASSWORD_INVALID"

  # validate of terms
  #validates_acceptance_of :terms, :allow_nil => false, :accept => true, :message => "TERMS_REQUIRED"

  before_save :encrypt_password

  def self.find_by_email(email)
    Mongki.find_by(email: email)
  end

  def self.find_by_phone(phone)
    Mongki.find_by(phone: phone)
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

  protected
  # encrypt password
  def encrypt_password
    self.password_encrypt = Password.create(:password)
  end

end
