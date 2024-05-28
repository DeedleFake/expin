defmodule ExpinWeb.AdminSettingsLive do
  use ExpinWeb, :live_view

  alias __MODULE__.{AccessTokensComponent, AccountComponent}

  @typep tab() :: %{
           :id => String.t(),
           :title => String.t(),
           :module => atom(),
           optional(:extra) => [atom()]
         }

  @base_title " · Settings"

  @impl true
  def render(assigns) do
    ~H"""
    <.tabs active={@active_tab}>
      <:tab :for={tab <- tabs()} id={tab.id} title={tab.title}>
        <.live_component
          :if={tab[:module]}
          module={tab.module}
          id={tab.id}
          {tab_extra(assigns, tab[:extra])}
        />
      </:tab>
    </.tabs>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:token, params["token"])

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"active_tab" => active_tab}, _uri, socket) do
    %{title: tab_title} = find_tab(active_tab)

    socket =
      socket
      |> assign(:page_title, "#{tab_title}#{@base_title}")
      |> assign(:active_tab, active_tab)

    {:noreply, socket}
  end

  @impl true
  def handle_params(_params, _uri, %{assigns: %{live_action: :index}} = socket) do
    {:noreply, push_patch(socket, to: ~p"/_/settings/access_tokens", replace: true)}
  end

  @impl true
  def handle_event("change_tab", %{"tab-id" => tab_id}, socket) do
    socket =
      socket
      |> push_patch(to: ~p"/_/settings/#{URI.encode_www_form(tab_id)}")

    {:noreply, socket}
  end

  @spec tabs() :: [tab()]
  defp tabs(),
    do: [
      %{id: "access_tokens", title: "Access Tokens", module: AccessTokensComponent},
      %{id: "admins", title: "Administrators"},
      %{
        id: "account",
        title: "Account",
        module: AccountComponent,
        extra: [:current_admin, :token]
      }
    ]

  @spec find_tab(String.t()) :: tab() | nil
  defp find_tab(id) do
    tabs() |> Enum.find(fn %{id: tab} -> id == tab end)
  end

  defp tab_extra(_assigns, nil), do: []
  defp tab_extra(assigns, extra), do: assigns |> Enum.filter(fn {key, _} -> key in extra end)
end
