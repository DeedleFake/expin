defmodule ExpinWeb.AdminSettingsLive do
  use ExpinWeb, :live_view

  alias __MODULE__.{AccessTokensComponent, AccountComponent}

  def mount(%{"token" => token}, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Admin Settings")
      |> assign(:token, token)

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :token, nil)}
  end

  def handle_params(%{"active_tab" => active_tab}, _uri, socket) do
    {:noreply, assign(socket, :active_tab, active_tab)}
  end

  def handle_params(_params, _uri, %{assigns: %{live_action: :index}} = socket) do
    {:noreply, push_patch(socket, to: ~p"/_/settings/access_tokens", replace: true)}
  end

  def handle_event("change_tab", %{"value" => tab_id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/_/settings/#{URI.encode_www_form(tab_id)}")}
  end
end
