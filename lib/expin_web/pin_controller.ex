defmodule ExpinWeb.PinController do
  use ExpinWeb, :controller

  def list(conn, _params) do
    conn |> json(%{this: :is, a: :test})
  end
end
