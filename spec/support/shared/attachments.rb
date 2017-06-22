shared_examples "delete attachment" do
  let(:delete_attachment) do
    patch :update, xhr: true, params: {
      id: attachable,
      attachable.class.name.underscore => {
        title: "Title",
        body: "Body",
        attachments_attributes: { "0": { _destroy: 1, id: attachment } }
      }
    }.merge(context_params)
  end

  context "owner" do
    let(:attachable) { owned_attachable }
    let!(:attachment) { create(:attachment, attachable: attachable) }

    it "deletes attachment" do
      expect { delete_attachment }.to change(attachable.attachments, :count).by(-1)
    end
  end

  context "not owner" do
    let!(:attachment) { create(:attachment, attachable: attachable) }

    it "does not deletes attachment" do
      expect { delete_attachment }.not_to change(attachable.attachments, :count)
    end
  end
end
