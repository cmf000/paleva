class Shift < ApplicationRecord
  belongs_to :restaurant
  enum weekday: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
  validates :weekday, :opening_time, :closing_time, presence: true
  validate :open_before_close
  validate :shifts_must_not_overlap, if: ->{restaurant_id.present?}

  private
  def open_before_close
    if opening_time.present? && closing_time.present?
      unless opening_time < closing_time
        errors.add(:closing_time, "deve ser depois do horário de início do turno.")  
      end
    end
  end

  def shifts_must_not_overlap
    shifts = restaurant.shifts.where(weekday: weekday)
    overlapping_shifts = shifts.where("opening_time < ? AND closing_time > ?", self.closing_time, self.opening_time)
    if overlapping_shifts.any?
      errors.add(:base, 'Turnos não podem sobrepor uns aos outros')
    end
  end
end
