shared_context "shared job", type: :job do
  let(:hash) { {} }
end

shared_context "test queue adapter", :test_queue_adapter do
  around do |example|
    active_job_queue_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
    example.run
    ActiveJob::Base.queue_adapter = active_job_queue_adapter
  end
end

shared_examples "broadcast to ActionCable" do
  it "broadcasts to ActionCable" do
    expect(ActionCable.server).to receive(:broadcast).with(channel, hash_including(hash))
    described_class.perform_now(record)
  end
end

shared_examples "job perform" do
  it "matches params with enqueued job", :test_queue_adapter do
    expect { described_class.perform_later(record) }.to have_enqueued_job.with(record)
  end
end
