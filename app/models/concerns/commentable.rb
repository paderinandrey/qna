module Commentable
  extend ActiveSupport::Concern
  
  include do
    has_many :comments, as: :commentable, dependent: :destroy
  end
end
