# Purpose of This Application
Create podcast feeds that can be uploaded to a server as static files.

These feeds can be created manually or from a YouTube playlist.

## Planned Features
- [x] Manual creation of feeds
- [ ] Downloading YouTube playlists
- [ ] Importing RSS files into existing feeds
- [ ] Be able to play episodes inside the application
- [ ] Configure remote servers as deployment targets
- [ ] Upload podcasts as static files via SFTP over SSH
- [ ] Encryption of Server#private_key

## Not Implementing
- Automatic updates from remote sources
- Robust handling of RSS files
- Implementing other protocols for uploading files
- Any services or dependencies outside the application's container
- Access controls beyond login

# Why I Built This
I have a number of rake scripts which convert YouTube playlists in to podcasts.

I also have multiple RPG games with friends I've recorded. Each one of these has had a custom script.

It's been a long time since I've done work in public and I haven't learned Rails 8 yet, so I thought this would be a fun project.

Note: comments in this application are very similar to what I do at work. I like to document why I made certain decisions because I won't remember them 2 years from now.

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
