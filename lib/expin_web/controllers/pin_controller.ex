defmodule ExpinWeb.PinController do
  use ExpinWeb, :controller

  alias Expin.Pins

  action_fallback __MODULE__.Fallback

  def list(conn, _params) do
    conn |> render(:index, %{pins: Pins.list_pins()})
  end

  def add(conn, _params) do
    conn |> json(%{not: :implemented, access_token: conn.assigns[:access_token].comment})
  end

  def get(conn, %{"request_id" => request_id}) do
    with {:ok, pin} <- Pins.fetch_pin(request_id) do
      conn |> render(:show, %{pin: pin})
    end
  end

  def replace(conn, %{"request_id" => request_id}) do
    conn
    |> json(%{
      not: :implemented,
      request_id: request_id,
      access_token: conn.assigns[:access_token].comment
    })
  end

  def remove(conn, %{"request_id" => request_id}) do
    conn
    |> json(%{
      not: :implemented,
      request_id: request_id,
      access_token: conn.assigns[:access_token].comment
    })
  end

  defmodule Fallback do
    use ExpinWeb, :controller

    def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
      conn
      |> put_status(:unprocessable_entity)
      |> render(:error, %{reason: "INTERNAL_SERVER_ERROR", details: changeset.errors})
    end

    def call(conn, {:error, %Ecto.NoResultsError{}}) do
      conn
      |> put_status(:not_found)
      |> render(:error, %{reason: "NOT_FOUND", details: "The requested pin was not found."})
    end
  end
end
