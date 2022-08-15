class LinepayService
  def initialize(api_type)
    @api_type = api_type
  end

  def perform(body)
    @body = body
    hmac64()
    puts @api_type
    resp = Faraday.post("#{ENV['line_pay_endpoint']}#{@api_type}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
      req.headers['X-LINE-Authorization-Nonce'] = @nonce
      req.headers['X-LINE-Authorization'] = @hmac64
      req.body = @body.to_json
    end
    @result = JSON.parse(resp.body)
  end
  
  def hmac64
    #Signature = Base64(HMAC-SHA256(Your ChannelSecret, (Your ChannelSecret + URI + RequestBody + nonce)))
    @nonce = SecureRandom.uuid
    secrect = ENV['line_pay_channel_secret']
    message = "#{secrect}#{@api_type}#{@body.to_json}#{@nonce}"
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secrect, message)
    @hmac64 = Base64.strict_encode64(hash)
  end

  def success?
    @result["returnCode"] == '0000'
  end

  def payment_url
    @result["info"]["paymentUrl"]["web"]
  end

  def order
    {
      order_id: @result["info"]["orderId"],
      transaction_id: @result["info"]["transactionId"]
    }
  end
end
