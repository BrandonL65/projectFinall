class Quote < ActiveRecord::Base
    has_many :answers
    has_many :candidates, through: :answers


end