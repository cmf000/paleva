class Shift < ApplicationRecord
  belongs_to :restaurant
  enum weekday: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
  validates :weekday, :opening_time, :closing_time, presence: true
  validate :open_before_close

  private
  def open_before_close
    if opening_time.present? && closing_time.present?
      unless opening_time < closing_time
        errors.add(:closing_time, "deve ser depois do horário de início do turno.")  
      end
    end
  end
end
