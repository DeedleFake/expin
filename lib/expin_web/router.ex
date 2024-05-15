defmodule ExpinWeb.Router do
  use ExpinWeb, :router

  import ExpinWeb.AdminAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExpinWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_admin
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug ExpinWeb.Plugs.TokenAuth
  end

  scope "/pins", ExpinWeb do
    pipe_through :api

    get "/", PinController, :list
    post "/", PinController, :add
    get "/:request_id", PinController, :get
    post "/:request_id", PinController, :replace
    delete "/:request_id", PinController, :remove
  end

  scope "/_", ExpinWeb do
    pipe_through [:browser, :redirect_if_admin_is_authenticated]

    get "/", Plugs.Redirect, to: "/_/log_in"

    live_session :redirect_if_admin_is_authenticated,
      on_mount: [{ExpinWeb.AdminAuth, :redirect_if_admin_is_authenticated}] do
      live "/register", AdminRegistrationLive, :new
      live "/log_in", AdminLoginLive, :new
      live "/reset_password", AdminForgotPasswordLive, :new
      live "/reset_password/:token", AdminResetPasswordLive, :edit
    end

    post "/log_in", AdminSessionController, :create
  end

  scope "/_", ExpinWeb do
    pipe_through [:browser, :require_authenticated_admin]

    live_session :require_authenticated_admin,
      on_mount: [{ExpinWeb.AdminAuth, :ensure_authenticated}] do
      live "/settings", AdminSettingsLive, :edit
      live "/settings/confirm_email/:token", AdminSettingsLive, :confirm_email
    end
  end

  scope "/_", ExpinWeb do
    pipe_through [:browser]

    delete "/log_out", AdminSessionController, :delete

    live_session :current_admin,
      on_mount: [{ExpinWeb.AdminAuth, :mount_current_admin}] do
      live "/confirm/:token", AdminConfirmationLive, :edit
      live "/confirm", AdminConfirmationInstructionsLive, :new
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:expin, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ExpinWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
