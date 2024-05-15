defmodule ExpinWeb.AdminSettingsLive.AccountComponent do
  use ExpinWeb, :live_component

  alias Expin.Admins

  def update(assigns, socket) do
    socket =
      with %{token: token} when not is_nil(token) <- assigns,
           :ok <- Admins.update_admin_email(assigns.current_admin, token) do
        put_flash(socket, :info, "Email changed successfully.")
      else
        %{} ->
          socket

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    admin = assigns.current_admin
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
      |> assign(:current_admin, admin)

    {:ok, socket}
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
end
