module AuthHelper
  def login 
    user = User.find_by(email: params[:email])
          
    if user&.authenticate(params[:password])
      token = AuthService.encode(user_id: user.id)
      { token: token, user: user.as_json(except: :password_digest) }
    else
      error!({ error: 'Invalid email or password' }, 401)
    end
  end
  
  def signup
    user = User.new(
      username: params[:username],  
      email: params[:email],
      password: params[:password],
      bio: params[:bio]
    )
    if user.save
      token = AuthService.encode(user_id: user.id)
      { token: token, user: user.as_json(except: :password_digest) }
    else
      error!({ errors: user.errors.full_messages }, 422)
    end
  end
end
