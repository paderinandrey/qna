module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      'provider': 'twitter',
      'uid': '12345',
      'info': {
        'email': '',
        'name': 'mockuser',
        'image': 'mock_user_thumbnail_url'
      },
      'credentials': {
        'token': 'mock_token',
        'secret': 'mock_secret'
      }
    })
    
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      'provider': 'facebook',
      'uid': '12345',
      'info': {
        'name': 'mockuser',
        'email': 'test@test.com',
        'image': 'mock_user_thumbnail_url'
      },
      'credentials': {
        'token': 'mock_token',
        'secret': 'mock_secret'
      }
    })
    
    OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
      'provider': 'linkedin',
      'uid': '12345',
      'info': {
        'name': 'mockuser',
        'email': 'test@test.com',
        'image': 'mock_user_thumbnail_url'
      },
      'credentials': {
        'token': 'mock_token',
        'secret': 'mock_secret'
      }
    })
  end
end
