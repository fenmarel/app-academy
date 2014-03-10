class SecretTagging < ActiveRecord::Base
  validates :secret, :tag, :presence => true

  belongs_to :secret
  belongs_to :tag
end
