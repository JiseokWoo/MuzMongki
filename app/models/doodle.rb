class Doodle
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :owner, type: BSON::ObjectId
  field :title, type: String
  #field :file, type: BSON::ObjectId
  field :contents, type: String
  #field :tags, type: Array

  validates_presence_of :owner

  validates_presence_of :title, :message => "필수 항목 입니다."
  validates_length_of :title,  maximum: 20, :message => "1자 이상 20자 이하로 작성하셔야 합니다."

  validates_presence_of :contents, :message => "필수 항목 입니다."
  validates_length_of :contents, maximum: 2000, :message => "2000자 이내로 작성하셔야 합니다."

  #validates_presence_of :tags, :message => "적어도 하나 이상 등록하셔야 합니다."
end
