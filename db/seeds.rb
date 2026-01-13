# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Creating seed data for Console feature..."

# Create test enterprise
enterprise = Enterprise.find_or_create_by!(email: "demo@playwith404.com") do |e|
  e.name = "Demo Enterprise"
  e.company_registration_number = "123-45-67890"
  e.contact_name = "홍길동"
  e.contact_phone = "010-1234-5678"
  e.plan_type = "growth"
  e.monthly_limit = 100000
  e.current_usage = 45230
  e.billing_cycle_start = Date.current.beginning_of_month
  e.status = "active"
  e.notes = "테스트용 기업 계정"
end

puts "Created enterprise: #{enterprise.name}"

# Create access token (the raw token will be shown once for testing)
access_token = enterprise.access_tokens.find_or_initialize_by(name: "Demo Access Token")
if access_token.new_record?
  access_token.save!
  puts "=" * 60
  puts "ACCESS TOKEN CREATED!"
  puts "Use this token to login to the console:"
  puts access_token.raw_token
  puts "=" * 60
  puts "(This token is only shown once. Save it somewhere safe!)"
else
  puts "Access token already exists for this enterprise"
end

# Create some API keys
[ "Production API Key", "Staging API Key", "Development API Key" ].each_with_index do |name, idx|
  env = %w[production staging development][idx]
  api_key = enterprise.api_keys.find_or_initialize_by(name: name)
  if api_key.new_record?
    api_key.environment = env
    api_key.save!
    puts "Created API key: #{name} (#{api_key.raw_key})"
  end
end

# Create sample API usage data (last 30 days)
endpoints = [
  "/api/v1/movies/recommend",
  "/api/v1/movies/search",
  "/api/v1/users/profile",
  "/api/v1/curations/generate",
  "/api/v1/emotions/analyze"
]

response_codes = [ 200, 200, 200, 200, 200, 200, 200, 200, 201, 400, 401, 404, 500 ]

if enterprise.api_usages.count < 100
  puts "Creating sample API usage data..."

  500.times do |i|
    enterprise.api_usages.create!(
      access_token: access_token,
      endpoint: endpoints.sample,
      method: %w[GET POST].sample,
      response_code: response_codes.sample,
      response_time_ms: rand(50..500),
      client_ip: "192.168.1.#{rand(1..255)}",
      user_agent: "CukeeSDK/1.0",
      cost: rand(0.001..0.01).round(4),
      created_at: rand(30.days).seconds.ago
    )
  end

  puts "Created 500 sample API usage records"
end

# Update current usage based on API calls
total_cost = enterprise.api_usages.sum(:cost)
enterprise.update!(current_usage: total_cost * 10000) # Convert to KRW

puts ""
puts "Seed data creation completed!"
puts "Enterprise: #{enterprise.name}"
puts "Plan: #{enterprise.plan_type_label}"
puts "API Usage Records: #{enterprise.api_usages.count}"
puts "API Keys: #{enterprise.api_keys.count}"
