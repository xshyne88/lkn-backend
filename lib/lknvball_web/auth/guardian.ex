defmodule LknvballWeb.Guardian do
  use Guardian, otp_app: :lknvball

  def subject_for_token(res, claims) do
    sub = res.id
    {:ok, sub}
  end

  # def subject_for_token(_, _) do
  #   {:error, :notfound}
  # end

  def resource_from_claims(claims) do
    id = claims["sub"]
    # need to add authenticity check and expiration
    {:ok, nil}
  end

  # def resource_from_claims(_) do
  #   {:error, :notfound}
  # end
end
