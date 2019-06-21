class Answer < ActiveRecord::Base
    belongs_to :quote
    belongs_to :candidate

end