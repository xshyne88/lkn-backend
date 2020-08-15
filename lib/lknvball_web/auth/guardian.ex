defmodule LknvballWeb.Guardian do
  use Guardian, otp_app: :lknvball

  def subject_for_token(res, _claims) do
    # need to add authenticity check and expiration
    {:ok, res}
  end

  # def subject_for_token(_, _) do
  #   {:error, :notfound}
  # end

  def resource_from_claims(res) do
    # need to add authenticity check and expiration
    {:ok, res}
  end

  # def resource_from_claims(_) do
  #   {:error, :notfound}
  # end
end
