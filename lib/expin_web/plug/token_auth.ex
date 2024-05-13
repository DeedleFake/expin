defmodule ExpinWeb.Plug.TokenAuth do
  import Plug.Conn

  alias Expin.AccessTokens
  alias AccessTokens.AccessToken

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "Authorization"),
         %AccessToken{} = access_token <- AccessTokens.get_access_token(token) do
      conn |> assign(:access_token, access_token)
    else
      _ -> conn |> send_resp(403, "not authorized") |> halt()
    end
  end
end
