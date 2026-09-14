require "json"
require "net/http"
require "securerandom"

class TurnstileVerification
  ENDPOINT = URI("https://challenges.cloudflare.com/turnstile/v0/siteverify")
  ACTION = "registration"

  Result = Data.define(:success?, :error_code)

  def initialize(token:, remote_ip:)
    @token = token
    @remote_ip = remote_ip
  end

  def verify
    return Result.new(false, "missing-token") if token.blank?
    return Result.new(false, "missing-configuration") if secret_key.blank? || expected_hostname.blank?

    response = Net::HTTP.start(
      ENDPOINT.host,
      ENDPOINT.port,
      use_ssl: true,
      open_timeout: 2,
      read_timeout: 3
    ) do |http|
      request = Net::HTTP::Post.new(ENDPOINT)
      request.set_form_data(
        secret: secret_key,
        response: token,
        remoteip: remote_ip,
        idempotency_key: SecureRandom.uuid
      )
      http.request(request)
    end

    payload = JSON.parse(response.body)
    return Result.new(false, payload.fetch("error-codes", ["verification-failed"]).first) unless payload["success"]
    return Result.new(false, "unexpected-action") unless payload["action"] == ACTION
    return Result.new(false, "unexpected-hostname") unless payload["hostname"] == expected_hostname

    Result.new(true, nil)
  rescue StandardError => error
    Rails.logger.warn("Turnstile verification unavailable: #{error.class}")
    Result.new(false, "verification-unavailable")
  end

  private

  attr_reader :token, :remote_ip

  def secret_key
    ENV["TURNSTILE_SECRET_KEY"]
  end

  def expected_hostname
    ENV["TURNSTILE_HOSTNAME"]
  end
end
