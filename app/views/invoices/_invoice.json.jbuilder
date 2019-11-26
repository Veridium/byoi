json.extract! invoice, :id, :plan_id, :user_id, :discount_id, :rebate_cents, :total_cents, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
