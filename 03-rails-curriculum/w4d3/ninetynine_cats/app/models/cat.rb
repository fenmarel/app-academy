class Cat < ActiveRecord::Base
  validates :color, inclusion: { in: ['black', 'blue', 'brown', 'tan', 'orange']}
  validates :sex, inclusion: { in: ['m', 'f']}
  validates :color, :sex, :name, :birthdate, :presence => true

  has_many :cat_rental_requests, :dependent => :destroy

  before_save :set_age!

  def set_age!
    self.age = (Date.today - self.birthdate).to_i / 365
  end
end