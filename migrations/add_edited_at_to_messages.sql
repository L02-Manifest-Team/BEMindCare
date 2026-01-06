-- Add edited_at column to messages table for message edit tracking
ALTER TABLE messages 
ADD COLUMN edited_at DATETIME NULL AFTER created_at;
