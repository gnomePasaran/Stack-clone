class ChangeAttachmentToPolymorphic < ActiveRecord::Migration[5.0]
  def change
    remove_column :attachments, :question_id
    add_reference :attachments, :attachable, polymorphic: true, index: true
  end
end
