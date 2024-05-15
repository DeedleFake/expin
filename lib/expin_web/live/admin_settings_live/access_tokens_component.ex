defmodule ExpinWeb.AdminSettingsLive.AccessTokensComponent do
  use ExpinWeb, :live_component

  alias Expin.AccessTokens

  def mount(socket) do
    tokens = AccessTokens.list_access_tokens()

    socket =
      socket
      |> stream_configure(:tokens, dom_id: & &1.token)
      |> stream(:tokens, tokens)
      |> assign(:form, to_form(%{"comment" => ""}))
      |> assign(:generated_token, nil)

    {:ok, socket}
  end

  def handle_event("generate", params, socket) do
    %{"comment" => comment} = params

    attr = %{
      comment: comment |> String.trim()
    }

    socket =
      case AccessTokens.generate_access_token(attr) do
        {:ok, access_token, token} ->
          socket
          |> assign(:generated_token, token)
          |> stream_insert(:tokens, access_token, at: 0)

        {:error, err} ->
          put_flash(socket, :error, "Failed to generate token: #{err}")
      end

    {:noreply, socket}
  end

  def handle_event("hide_modal", _params, socket) do
    {:noreply, assign(socket, :generated_token, nil)}
  end
end
