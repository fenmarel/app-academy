class Article < ActiveRecord::Base
  has_many :comments
  has_many :taggings
  has_many :tags, through: :taggings

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(tag_str)
    list = tag_str.downcase.split(', ').map(&:strip).uniq

    self.tags = list.map do |tag|
      Tag.find_or_create_by(name: tag)
    end
  end
end
