defmodule ExpinWeb.PinController do
  use ExpinWeb, :controller

  alias Expin.Pins

  action_fallback __MODULE__.Fallback

  def list(conn, _params) do
    conn |> render(:index, %{pins: Pins.list_pins()})
  end

  def add(conn, %{"cid" => cid} = params) do
    opts = params_to_keyword(params, [:name, :origins, :meta])
    Pins.queue_add_pin(cid, opts)
    conn |> json(%{not: :implemented})
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

  defp params_to_keyword(params, names) when is_map(params) and is_list(names) do
    Enum.reduce(names, [], fn
      {name, key}, keyword when is_map_key(params, key) ->
        [{name, params[key]} | keyword]

      name, keyword when is_atom(name) ->
        key = Atom.to_string(name)

        if is_map_key(params, key) do
          [{key, params[name]} | keyword]
        else
          keyword
        end

      _name, keyword ->
        keyword
    end)
    |> Enum.reverse()
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
