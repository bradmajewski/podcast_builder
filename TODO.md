# Cleanup
- Add controller tests for all actions that render views to catch exceptions.

# Next Step
- Load a podcast into the application

# Ideas
- Consider adding episode numbers and acts_as_list. (This is track in the metadata)
- Adds something other than the episode id from the database as a file name. Maybe use title as a slug?
- Add unit tests for all foreign key dependencies
- Reprocess audio files into a specific format.
  - Offer to optimize for voice: 64kbps mono
- Full cucumber coverage for all CRUD operations
- Add a template for description on the podcast model (use regex to replace {{track_number}})