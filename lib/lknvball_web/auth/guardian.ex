defmodule LknvballWeb.Guardian do
  use Guardian, otp_app: :lknvball

  # TODO: pretty sure this library is mostely broken
  # for now need to make sure

  def subject_for_token(res, _claims) do
    {:ok, res}
  end

  # def subject_for_token(_, _) do
  #   {:error, :notfound}
  # end

  def resource_from_claims(%{"sub" => user}) do
    # {:ok, resource} or {:error, reason}
    {:ok, user}
  end

  # def resource_from_claims(_) do
  #   {:error, :notfound}
  # end
end
