module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :commented_objects, as: :commentable
    has_many :comments, through: :commented_objects
  end
end