class Episode < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :podcast
end
