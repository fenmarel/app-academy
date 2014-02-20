class CatRentalRequest < ActiveRecord::Base

  validates :status, inclusion: { in: ['PENDING', "APPROVED", "DENIED"] }
  validates :status, :cat_id, :end_date, :start_date, :presence => true
  validate :not_overlapping_approved_requests

  belongs_to :cat


  def approve!
    ActiveRecord::Base.transaction do
      self.status = "APPROVED"
      self.save

      @cat = Cat.find(self.cat_id)
      pending = @cat.cat_rental_requests.where(status: 'PENDING')

      pending.each do |pending_request|
        if overlapping_requests(pending_request)
          pending_request.deny!
        end
      end
    end
  end

  def deny!
    self.status = "DENIED"
    self.save
  end


  private

  def overlapping_requests(cat_request)
    self_timespan = (self.start_date..self.end_date)
    request_timespan = (cat_request.start_date..cat_request.end_date)

    self_timespan.any? { |day| request_timespan.include?(day) }
  end

  def not_overlapping_approved_requests
    return if self.cat_id.nil? || self.status == "DENIED"

    @cat = Cat.find(self.cat_id)
    approved = @cat.cat_rental_requests.where(status: 'APPROVED')

    approved.each do |request|
      if overlapping_requests(request)
        errors[:cat_rental_request] << "cannot overlap rental dates"
      end
    end
  end
end
