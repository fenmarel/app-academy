# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Journal::Application.config.secret_key_base = 'c0dcc9475c8ee4186dbbaa7e2338dcd6faafce2cad4e6d54549908cb01aa9502d5292479b61bc7b79e69f50a604e93c4f9ea5f2123da0ecaee622b87c1eb597e'
