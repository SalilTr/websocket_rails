class Message < ApplicationRecord
  after_create_commit :broadcast_message

  def broadcast_message
    Rails.logger.info("WebSocket: Broadcasting message with id #{self.id}")
    
    ActionCable.server.broadcast("messages_channel", {
      id:id,
      body:body
      # Add other attributes you want to broadcast
    })

    Rails.logger.info("WebSocket: Message broadcasted successfully")
  rescue StandardError => e
    Rails.logger.error("WebSocket: Error in broadcast_message - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end
end
