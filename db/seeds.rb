# db/seeds.rb
# This file should ensure the existence of records required to run the application in every environment (production, development, test).
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# Create Subscription Plans
puts "Creating subscription plans..."

plans = [
  {
    name: "Free Trial",
    generations_per_month: 1,
    price_cents: 0,
    allows_export: false,
    stripe_price_id: nil
  },
  {
    name: "Starter",
    generations_per_month: 3,
    price_cents: 99900, # KES 999 (adjust as needed)
    allows_export: true,
    stripe_price_id: "price_starter" # Will be updated with actual Paystack price ID
  },
  {
    name: "Growth",
    generations_per_month: 8,
    price_cents: 249900, # KES 2,499
    allows_export: true,
    stripe_price_id: "price_growth"
  },
  {
    name: "Pro",
    generations_per_month: -1, # -1 indicates unlimited
    price_cents: 499900, # KES 4,999
    allows_export: true,
    stripe_price_id: "price_pro"
  }
]

plans.each do |plan_data|
  plan = SubscriptionPlan.find_or_create_by(name: plan_data[:name]) do |p|
    p.generations_per_month = plan_data[:generations_per_month]
    p.price_cents = plan_data[:price_cents]
    p.allows_export = plan_data[:allows_export]
    p.stripe_price_id = plan_data[:stripe_price_id]
  end
  
  puts "  ✓ #{plan.name} - #{plan.price_cents / 100.0} KES/month, #{plan.generations_per_month == -1 ? 'Unlimited' : plan.generations_per_month} generations"
end

puts "✅ Database seeded successfully!"
