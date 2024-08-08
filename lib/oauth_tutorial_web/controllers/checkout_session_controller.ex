defmodule OauthTutorialWeb.CheckoutSessionController do
  use OauthTutorialWeb, :controller
  alias HTTPoison
  require Logger

  @stripe_secret_key "sk_test_51PhdC0KpQ0JFa0DDfK2oNDlen86HRvbC5rALTSnhpADi4fijr64L45zMakKX1z7L3muq9Va1A0lTghZd4hi3jVLs00oiWQUOeW"
  @stripe_payment_intent_endpoint "https://api.stripe.com/v1/payment_intents"
  # @stripe_secret_key "STRIPE_SECRET_KEY"
  # @stripe_checkout_endpoint "STRIPE_CHECKOUT_SESSION_ENDPOINT"

  def create(conn, %{"amount" => amount, "paymentMethodId" => paymentMethodId, "currency" => currency}) do
    headers = [
      {"Authorization", "Bearer #{@stripe_secret_key}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
    Logger.info("--------123------ #{inspect(headers)}")

    body = URI.encode_query(%{
      "amount" => amount * 100,
      "currency" => currency,
      "payment_method" => paymentMethodId,
      "confirm" => "true",
      "off_session" => "true"
    })

    Logger.info("--------here------ #{inspect(body)}")
    # Create a PaymentIntent
    case HTTPoison.post(@stripe_payment_intent_endpoint, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        # Parse and respond with the response body
        conn
        |> put_status(:ok)
        |> json(response_body |> Jason.decode!())

      {:ok, %HTTPoison.Response{status_code: status, body: response_body}} ->
        Logger.error("Failed with status #{status}: #{response_body}")
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Failed to create PaymentIntent"})

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Request failed: #{inspect(reason)}")
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Request failed"})

      # {:error, %HTTPoison.Error{reason: reason}} ->
      #   Logger.error("Failed to create checkout session: #{reason}")
      #   json(conn, %{error: "Failed to create checkout session"})
    end
  end

  # Ensure you have a clause for requests with incorrect or missing parameters
  def create(conn, _) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Invalid parameters"})
  end
end
