class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true

  validates :file, :attachable_id, :attachable_type, presence: true

  mount_uploader :file, FileUploader
end
