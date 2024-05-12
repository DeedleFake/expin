defmodule ExpinWeb.PinController do
  use ExpinWeb, :controller

  def list(conn, _params) do
    conn |> json(%{not: :implemented})
  end

  def add(conn, _params) do
    conn |> json(%{not: :implemented})
  end

  def get(conn, %{"request_id" => request_id}) do
    conn |> json(%{not: :implemented, request_id: request_id})
  end

  def replace(conn, %{"request_id" => request_id}) do
    conn |> json(%{not: :implemented, request_id: request_id})
  end

  def remove(conn, %{"request_id" => request_id}) do
    conn |> json(%{not: :implemented, request_id: request_id})
  end
end
