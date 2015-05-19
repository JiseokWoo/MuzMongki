class Doodle
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  attr_accessor :tag_list

  field :owner, type: BSON::ObjectId, default: nil
  field :title, type: String, default: nil
  field :contents, type: String, default: nil
  field :tags, type: Array, default: nil
  
  before_save :handle_tags, :convert_contents

  validates_presence_of :owner

  validates_presence_of :title, :message => "필수 항목 입니다."
  validates_length_of :title,  maximum: 20, :message => "1자 이상 20자 이하로 작성하셔야 합니다."

  validates_presence_of :contents, :message => "필수 항목 입니다."
  validates_length_of :contents, maximum: 2000, :message => "2000자 이내로 작성하셔야 합니다."

  validates_presence_of :tags, :message => "적어도 하나 이상 등록하셔야 합니다."

  private
  def handle_tags
    self.tags.map!(&:downcase)
    self.tags.uniq!
  end

  def convert_contents
    self.contents.gsub!(/\r\n/m,"<br>")
  end
end
