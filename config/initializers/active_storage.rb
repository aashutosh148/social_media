ActiveSupport.on_load(:active_storage_attachment) do
  after_commit :enqueue_image_processing, on: :create
  
  private
  
  def enqueue_image_processing
    return unless blob.content_type.start_with?('image/')
    
    record_type = record.class.name
    record_id = record.id
    attachment_name = name
    
    ImageProcessingWorker.perform_async(record_type, record_id, attachment_name)
  end
end