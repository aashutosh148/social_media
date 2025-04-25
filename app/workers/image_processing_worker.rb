class ImageProcessingWorker
  include Sidekiq::Worker
  
  def perform(record_type, record_id, attachment_name)
    record = record_type.constantize.find_by(id: record_id)
    return unless record
    
    attachment = record.send(attachment_name)
    return unless attachment.attached?
    
    # Process images for different formats/sizes
    if attachment.content_type.start_with?('image/')
      attachment.variant(resize_to_limit: [1200, 1200]).processed
      attachment.variant(resize_to_fill: [400, 400]).processed if record_type == 'User'
    end
  end
end