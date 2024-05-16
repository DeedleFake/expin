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

  def pin_ls(req \\ nil, opts \\ nil) do
    {req, opts} = normalize_args(req, opts)
    opts = Keyword.validate!(opts, [:type, :quiet, :names])

    Req.post(req, url: "pin/ls", params: opts) |> normalize_return()
  end

  defp normalize_args(req, opts) do
    if opts == nil do
      cond do
        Keyword.keyword?(req) -> {new(), req}
        req == nil -> {new(), []}
        true -> {req, []}
      end
    else
      if req == nil do
        {new(), opts}
      else
        {req, opts}
      end
    end
  end

  defp normalize_return({:ok, %{body: body}}), do: {:ok, body}
  defp normalize_return({:error, _} = err), do: err
end
