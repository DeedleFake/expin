defmodule ExpinWeb.PinController do
  use ExpinWeb, :controller

  def list(conn, _params) do
    conn |> json(%{not: :implemented, access_token: conn.assigns[:access_token]})
  end

  def add(conn, _params) do
    conn |> json(%{not: :implemented, access_token: conn.assigns[:access_token]})
  end

  def get(conn, %{"request_id" => request_id}) do
    conn
    |> json(%{
      not: :implemented,
      request_id: request_id,
      access_token: conn.assigns[:access_token]
    })
  end

  def replace(conn, %{"request_id" => request_id}) do
    conn
    |> json(%{
      not: :implemented,
      request_id: request_id,
      access_token: conn.assigns[:access_token]
    })
  end

  def remove(conn, %{"request_id" => request_id}) do
    conn
    |> json(%{
      not: :implemented,
      request_id: request_id,
      access_token: conn.assigns[:access_token]
    })
  end
end
