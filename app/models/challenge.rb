class Challenge < ApplicationRecord
    belongs_to :user
    validates :title, presence: true
    validates :description, presence: true
    validates :start_date, presence: true
    validates :end_date, presence: true

    scope :active, -> { where('start_date<=? AND end_date>=?', Date.today, Date.today) }
    scope :upcoming, -> {where('start_date>?',Date.today)}
end
