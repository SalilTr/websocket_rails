class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "MessagesChannel"
    Rails.logger.info("WebSocket: User subscribed to MessagesChannel")
  rescue StandardError => e
    Rails.logger.error("WebSocket: Error in subscribed - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end
 
  def unsubscribed
    Rails.logger.info("WebSocket: User unsubscribed from MessagesChannel")
  rescue StandardError => e
    Rails.logger.error("WebSocket: Error in unsubscribed - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end
end
