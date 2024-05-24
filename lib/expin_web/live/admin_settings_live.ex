defmodule ExpinWeb.AdminSettingsLive do
  use ExpinWeb, :live_view

  alias __MODULE__.{AccessTokensComponent, AccountComponent}

  @base_title " · Settings"

  @impl true
  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:token, params["token"])

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"active_tab" => active_tab}, _uri, socket) do
    {:noreply, assign(socket, :active_tab, active_tab)}
  end

  @impl true
  def handle_params(_params, _uri, %{assigns: %{live_action: :index}} = socket) do
    {:noreply, push_patch(socket, to: ~p"/_/settings/access_tokens", replace: true)}
  end

  @impl true
  def handle_event("change_tab", %{"tab-id" => tab_id, "tab-title" => tab_title}, socket) do
    socket =
      socket
      |> assign(:page_title, "#{tab_title}#{@base_title}")
      |> push_patch(to: ~p"/_/settings/#{URI.encode_www_form(tab_id)}")

    {:noreply, socket}
  end
end
