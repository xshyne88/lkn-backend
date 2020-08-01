defmodule LknvballWeb.Guardian do
  use Guardian, otp_app: :lknvball

  def subject_for_token(res, _claims) do
    IO.inspect(res, label: "subject for token: ")
    {:ok, res}
  end

  # def subject_for_token(_, _) do
  #   {:error, :notfound}
  # end

  @spec resource_from_claims(any) :: {:ok, any}
  def resource_from_claims(res) do
    IO.inspect(res, label: "resource from claims: ")
    {:ok, res}
  end

  # def resource_from_claims(_) do
  #   {:error, :notfound}
  # end
end
