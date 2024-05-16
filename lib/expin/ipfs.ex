defmodule Expin.IPFS do
  @moduledoc """
  Provides a simple wrapper around the Kubo RPC API.
  """

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
  def pin_ls(opts) when is_list(opts), do: pin_ls(new(), opts)

  def pin_ls(%Req.Request{} = req, opts \\ []) when is_list(opts) do
    opts = Keyword.validate!(opts, [:type, :quiet, :stream, :names])

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
    opts = Keyword.validate!(opts, [:unpin]) |> Kernel.++(arg: old_path, arg: new_path)

    Req.post(req, url: "pin/update", params: opts) |> normalize_return()
  end

  defp normalize_return({:ok, %{body: body}}), do: {:ok, body}
  defp normalize_return({:error, _} = err), do: err
end