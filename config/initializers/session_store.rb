# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_hermes-client_session',
  :secret => '0a20ef7f02a12f74e83ac56539aab8b75641b7e198b46ac5ac7fe3a7c01aa728db5b12751c14ffd55ff317aa3ec69060872e6de59d017bd821e47b85469b19db'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
