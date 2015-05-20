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

  mount_uploader :avatar, AvatarUploader

  #field :token, type: String, default: nil
  
  field :email_confirm, type: Boolean, default: false
  field :email_confirm_text, type: String, default: nil
  #field :terms, type: BSON::ObjectId

  before_validation :downcase_field
  before_save :encrypt_password

  # validate of email
  validates_presence_of :email, :message => "주소는 필수 항목 입니다."
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, :message => "주소 형식이 맞지 않습니다."
  validates_uniqueness_of :email, :case_sensitive => false, :message => "주소로 이미 가입되어 있습니다."

  # validate of name
  validates_presence_of :name, :message => "은 필수 항목 입니다."
  validates_format_of :name, with: /[a-z0-9\-_]{3,15}/i, :message => "은 영문 알파벳, 숫자, -, _ 조합으로 3자 이상 15자 이하여야 합니다."
  validates_uniqueness_of :name, :case_sensitive => false, :message => "이 이미 존재합니다."
  #validates_exclusion_of :name, in: ProhibitedWord, :message => "contains Prohibited word!"

  # validate of password
  validates_length_of :password, minimum: 6, maximum: 15, :message => "는 6자 이상 15자 이하여야 합니다."
  validates_confirmation_of :password, :message => "가 일치하지 않습니다."

  # validate of terms
  #validates_acceptance_of :terms, :allow_nil => false, :accept => true, :message => "TERMS_REQUIRED"

  def self.authenticate(id, password)
    mongki = Mongki.find_by(id: id)
    mongki && mongki.authenticate(password)
  end

  def authenticate(password)
    password = BCrypt::Engine.hash_secret(password, $mongki_salt)
    password == self.password_encrypt
  end

  def email_confirm?
    self.email_confirm
  end

  private
  def encrypt_password
    self.password_encrypt= BCrypt::Engine.hash_secret(password, $mongki_salt)
  end

  def downcase_field
    self.email= self.email.downcase
  end

end
