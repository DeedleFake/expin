defmodule ExpinWeb.AdminSettingsLive do
  use ExpinWeb, :live_view

  alias Expin.Admins

  def render(assigns) do
    ~H"""
    <.tabs active={@active_tab}>
      <:tab id="access_tokens" title="Access Tokens">
        <.header class="text-center">
          Access Tokens
          <:subtitle>Create and remove pinning service access tokens</:subtitle>
        </.header>
        Not implemented.
      </:tab>

      <:tab id="admins" title="Administrators">
        <.header class="text-center">
          Administrators
          <:subtitle>Create and remove administrators</:subtitle>
        </.header>
        Not implemented.
      </:tab>

      <:tab id="account" title="Account">
        <.header class="text-center">
          Account Settings
          <:subtitle>Manage your account email address and password settings</:subtitle>
        </.header>

        <div class="space-y-12 divide-y">
          <div>
            <.simple_form
              for={@email_form}
              id="email_form"
              phx-submit="update_email"
              phx-change="validate_email"
            >
              <.input field={@email_form[:email]} type="email" label="Email" required />
              <.input
                field={@email_form[:current_password]}
                name="current_password"
                id="current_password_for_email"
                type="password"
                label="Current password"
                value={@email_form_current_password}
                required
              />
              <:actions>
                <.button phx-disable-with="Changing...">Change Email</.button>
              </:actions>
            </.simple_form>
          </div>
          <div>
            <.simple_form
              for={@password_form}
              id="password_form"
              action={~p"/_/log_in?_action=password_updated"}
              method="post"
              phx-change="validate_password"
              phx-submit="update_password"
              phx-trigger-action={@trigger_submit}
            >
              <input
                name={@password_form[:email].name}
                type="hidden"
                id="hidden_admin_email"
                value={@current_email}
              />
              <.input field={@password_form[:password]} type="password" label="New password" required />
              <.input
                field={@password_form[:password_confirmation]}
                type="password"
                label="Confirm new password"
              />
              <.input
                field={@password_form[:current_password]}
                name="current_password"
                type="password"
                label="Current password"
                id="current_password_for_password"
                value={@current_password}
                required
              />
              <:actions>
                <.button phx-disable-with="Changing...">Change Password</.button>
              </:actions>
            </.simple_form>
          </div>
        </div>
      </:tab>
    </.tabs>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Admins.update_admin_email(socket.assigns.current_admin, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/_/settings")}
  end

  def mount(_params, _session, socket) do
    admin = socket.assigns.current_admin
    email_changeset = Admins.change_admin_email(admin)
    password_changeset = Admins.change_admin_password(admin)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, admin.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_params(%{"active_tab" => active_tab}, _uri, socket) do
    {:noreply, assign(socket, :active_tab, active_tab)}
  end

  def handle_params(_params, _uri, %{assigns: %{live_action: :index}} = socket) do
    dbg(socket)
    {:noreply, push_patch(socket, to: ~p"/_/settings/access_tokens", replace: true)}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "admin" => admin_params} = params

    email_form =
      socket.assigns.current_admin
      |> Admins.change_admin_email(admin_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "admin" => admin_params} = params
    admin = socket.assigns.current_admin

    case Admins.apply_admin_email(admin, password, admin_params) do
      {:ok, applied_admin} ->
        Admins.deliver_admin_update_email_instructions(
          applied_admin,
          admin.email,
          &url(~p"/_/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "admin" => admin_params} = params

    password_form =
      socket.assigns.current_admin
      |> Admins.change_admin_password(admin_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "admin" => admin_params} = params
    admin = socket.assigns.current_admin

    case Admins.update_admin_password(admin, password, admin_params) do
      {:ok, admin} ->
        password_form =
          admin
          |> Admins.change_admin_password(admin_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  def handle_event("change_tab", %{"value" => tab_id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/_/settings/#{URI.encode_www_form(tab_id)}")}
  end
end
