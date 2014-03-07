# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
IeiriPoster::Application.config.secret_key_base = ENV['SECRET_TOKEN'] || '4da8cf1f4d6466a8fc65b6b6f4947ae0468877c270f5ce6acc2644813bc82a86e5db4147d7e0cc045c3569bc80a83bdf1d4f1183ef4c3d6a1ee6018a206ac3b7'
