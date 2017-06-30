class PurchasesController < ApplicationController
  def home
    @products = Product.order(:price)
    @remaining_kisses = Purchase.joins(:product).sum(:kiss_count)
  end

  def create
    token = params[:stripeToken]
    product = Product.find(params[:product_id])

    charge = Stripe::Charge.create(
      amount: product.price,
      currency: "usd",
      description: "#{product.name} - #{product.kiss_count} llama kisses",
      source: token,
    )

    Purchase.create!(
      product: product,
      stripe_charge_id: charge.id,
    )
  end
end
