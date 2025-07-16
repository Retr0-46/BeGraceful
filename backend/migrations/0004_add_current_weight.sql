-- Add current_weight_kg field to profiles table
ALTER TABLE profile.profiles ADD COLUMN current_weight_kg INT DEFAULT NULL;
 
-- Initialize current_weight_kg with weight_kg for existing profiles
UPDATE profile.profiles SET current_weight_kg = weight_kg WHERE current_weight_kg IS NULL; 