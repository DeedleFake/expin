defmodule ExpinWeb.Plugs.TokenAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Expin.AccessTokens

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, access_token} <- AccessTokens.fetch_access_token(token) do
      conn |> assign(:access_token, access_token)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> put_view(json: ExpinWeb.PinJSON)
        |> render(:error, %{reason: "UNAUTHORIZED", details: "access token is missing or invalid"})
    end
  end
end
