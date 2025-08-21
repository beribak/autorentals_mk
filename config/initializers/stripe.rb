Rails.application.configure do
  config.stripe = {
    publishable_key: ENV["STRIPE_PUBLISHABLE_KEY"],
    secret_key: ENV["STRIPE_SECRET_KEY"]
  }
end

Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
