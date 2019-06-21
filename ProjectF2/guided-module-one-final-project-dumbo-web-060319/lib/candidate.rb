class Candidate < ActiveRecord::Base
    has_many :answers
    has_many :quotes, through: :answers 
end