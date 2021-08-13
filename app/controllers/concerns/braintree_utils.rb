module BraintreeUtils
  def gateway
    Braintree::Gateway.new(
      environment: :sandbox,
      merchant_id: "ytcktzdx47s7t7xg",
      public_key: "vhncwx4r7rx9ys32",
      private_key: "7c05673f25e37aa62a2b569fc5d759ec"
    )
  end
end
