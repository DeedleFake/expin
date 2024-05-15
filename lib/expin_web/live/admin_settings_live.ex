defmodule ExpinWeb.AdminSettingsLive do
  use ExpinWeb, :live_view

  alias __MODULE__.{AccountComponent}

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
