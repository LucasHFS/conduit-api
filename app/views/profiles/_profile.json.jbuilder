# frozen_string_literal: true

json.call(user, :username, :bio)
json.image user.image || 'https://i.stack.imgur.com/xHWG8.jpg'
json.following signed_in? ? current_user.following?(user) : false
