class KaboomBatchJob < RocketJob::Job
  include RocketJob::Plugins::Batch

  self.destroy_on_complete = false

  def perform(record)
    if rocket_job_record_number % 2 == 0
      raise "Blowing up on record: #{rocket_job_record_number}"
    else
      raise ArgumentError, "Blowing up on record: #{rocket_job_record_number}"
    end
  end
end