defmodule ExpinWeb.Plugs.Redirect do
  import Phoenix.Controller

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    conn |> redirect(opts)
  end
end
