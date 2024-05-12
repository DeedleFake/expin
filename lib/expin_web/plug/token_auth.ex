defmodule ExpinWeb.Plug.TokenAuth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case get_req_header(conn, "Authorization") do
      ["Bearer " <> token] ->
        conn |> assign(:access_token, token)

      _ ->
        conn |> send_resp(403, "not authorized")
    end
  end
end
