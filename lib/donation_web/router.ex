defmodule DonationWeb.Router do
  use DonationWeb, :router

  alias Donation

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authenticate_admin do
    plug(DonationWeb.Plugs.SetCurrentAdmin)
    plug(DonationWeb.Plugs.AuthenticateAdmin)
  end

  pipeline :layout_admin do
    plug(:put_layout, {DonationWeb.LayoutView, :admin})
  end

  scope "/api", DonationWeb do
    pipe_through(:api)
    resources("/offerings", ContributionApiController, except: [:new, :edit])
    patch("/offerings/:reference_no/fpx", ContributionApiController, :fpx)
    patch("/offerings/:reference_no/cybersource", ContributionApiController, :cybersource)
  end

  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :donation, swagger_file: "swagger.json")
  end

  scope "/admins", DonationWeb do
    pipe_through([:browser])
    get("/sign-in", SessionController, :new)
    post("/sign-in", SessionController, :create)
    delete("/sign-out", SessionController, :delete)
  end

  scope "/admins", DonationWeb do
    pipe_through([:browser, :authenticate_admin, :layout_admin])
    resources("/receipts", ReceiptController, except: [:delete])
    get("/receipts/:id/generate_pdf", ReceiptController, :generate_pdf)
    resources("/reports", ReportController, only: [:index])
    resources("/type_of_contributions", TypeOfContributionController)
    resources("/type_of_payment_methods", TypeOfPaymentMethodController)
    resources("/users", UserController)
  end

  scope "/", DonationWeb do
    pipe_through(:browser)
    # delegate to react router here
    get("/*path", PageController, :index)
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Mass Offerings & Donations"
      }
    }
  end
end
