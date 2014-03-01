class Goal < ActiveRecord::Base
  include Commentable

  validates :title, :description, presence: true
  validates_inclusion_of :private_goal, :in => [true, false]

  belongs_to :user, :inverse_of => :goals
  has_many   :comments, dependent: :destroy, as: :commentable
end
