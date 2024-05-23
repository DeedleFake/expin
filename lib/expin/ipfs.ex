defmodule Expin.IPFS do
  @moduledoc """
  Provides a simple wrapper around the Kubo RPC API.
  """

  defmodule ServerError do
    defexception [:code, :message, :type]

    @impl true
    def exception(%{"Code" => code, "Message" => message, "Type" => type}) do
      %__MODULE__{code: code, message: message, type: type}
    end
  end

  def new(opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:base_url, "http://localhost:5001/api/v0")

    Req.new(opts)
  end

  def pin_add(path) when is_binary(path), do: pin_add(path, [])
  def pin_add(path, opts) when is_binary(path) and is_list(opts), do: pin_add(new(), path, opts)

  def pin_add(%Req.Request{} = req, path, opts \\ []) when is_binary(path) and is_list(opts) do
    opts = Keyword.validate!(opts, [:recursive, :name, :progress]) |> Keyword.put_new(:arg, path)

    Req.post(req, url: "pin/add", params: opts) |> normalize_return()
  end

  def pin_ls(), do: pin_ls([])

  def pin_ls(%Req.Request{} = req), do: pin_ls(req, [])
  def pin_ls(path) when is_binary(path), do: pin_ls(path, [])
  def pin_ls(opts) when is_list(opts), do: pin_ls(new(), opts)

  def pin_ls(path, opts) when is_binary(path) and is_list(opts), do: pin_ls(new(), path, opts)

  def pin_ls(%Req.Request{} = req, opts) when is_list(opts) do
    opts = Keyword.validate!(opts, [:type, :quiet, :stream, :names])

    Req.post(req, url: "pin/ls", params: opts) |> normalize_return()
  end

  def pin_ls(%Req.Request{} = req, path, opts \\ []) when is_binary(path) and is_list(opts) do
    opts =
      Keyword.validate!(opts, [:type, :quiet, :stream, :names]) |> Keyword.put_new(:arg, path)

    Req.post(req, url: "pin/ls", params: opts) |> normalize_return()
  end

  def pin_rm(path) when is_binary(path), do: pin_rm(path, [])
  def pin_rm(path, opts) when is_binary(path) and is_list(opts), do: pin_rm(new(), path, opts)

  def pin_rm(%Req.Request{} = req, path, opts \\ []) when is_binary(path) and is_list(opts) do
    opts = Keyword.validate!(opts, [:recursive]) |> Keyword.put_new(:arg, path)

    Req.post(req, url: "pin/rm", params: opts) |> normalize_return()
  end

  def pin_update(old_path, new_path) when is_binary(old_path) and is_binary(new_path),
    do: pin_update(old_path, new_path, [])

  def pin_update(old_path, new_path, opts)
      when is_binary(old_path) and is_binary(new_path) and is_list(opts),
      do: pin_update(new(), old_path, new_path, opts)

  def pin_update(%Req.Request{} = req, old_path, new_path, opts)
      when is_binary(old_path) and is_binary(new_path) and is_list(opts) do
    opts =
      Keyword.validate!(opts, [:unpin])
      |> then(&[{:arg, old_path}, {:arg, new_path} | &1])

    Req.post(req, url: "pin/update", params: opts) |> normalize_return()
  end

  def pin_verify(), do: pin_verify([])
  def pin_verify(opts) when is_list(opts), do: pin_verify(new(), opts)

  def pin_verify(%Req.Request{} = req, opts) when is_list(opts) do
    opts = Keyword.validate!(opts, [:verbose, :quiet])

    Req.post(req, url: "pin/verify", params: opts) |> normalize_return()
  end

  def swarm_connect(peer) when is_binary(peer), do: swarm_connect(new(), peer)

  def swarm_connect(%Req.Request{} = req, peer) when is_binary(peer) do
    Req.post(req, url: "swarm/connect", params: [arg: peer])
  end

  def resolve(path) when is_binary(path), do: resolve(path, [])
  def resolve(path, opts) when is_binary(path) and is_list(opts), do: resolve(new(), path, opts)

  def resolve(%Req.Request{} = req, path, opts) when is_binary(path) and is_list(opts) do
    opts =
      Keyword.validate!(opts, [:recursive, :"dht-record-count", :"dht-timeout"])
      |> Keyword.put_new(:arg, path)

    Req.post(req, url: "resolve", params: opts) |> normalize_return()
  end

  defp normalize_return({:ok, %Req.Response{status: 200, body: body}}), do: {:ok, body}

  defp normalize_return({:ok, %Req.Response{body: body}}),
    do: {:error, ServerError.exception(body)}

  defp normalize_return({:error, _} = err), do: err
end
