class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true
  
  mount_uploader :file, FileUploader
  
  #validates :file, :attachable_id, :attachable_type, presence: true
end
