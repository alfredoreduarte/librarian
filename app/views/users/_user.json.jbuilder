json.extract! user, :id, :token, :status, :email, :phone, :timezone, :ip_address, :project_id, :created_at, :updated_at
json.url user_url(user, format: :json)
