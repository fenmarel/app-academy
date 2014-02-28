class Link < ActiveRecord::Base
  validates :title, :url, :presence => true

  belongs_to :user

  has_many :link_subs
  has_many :subs, :through => :link_subs
  has_many :comments
  has_many :user_votes


  def comments_by_parent_id
    @comments = self.comments
    comment_map = {}

    @comments.each do |comment|
      comment_map[comment.id] = @comments.where("parent_comment_id = #{comment.id}")
    end
    comment_map
  end

  def parent_comments
    self.comments.where("parent_comment_id IS NULL")
  end

  def score
    self.user_votes.sum(:vote)
  end
end
