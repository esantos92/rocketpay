defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Pedro Sampaio",
        password: "quero12345",
        nickname: "DjPedro",
        email: "pedro.sampaio@email.com",
        age: "30"
      }

      {:ok, %User{account: % Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic ZXZlcnRvbjpxdWVybzEyMw==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}
      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
        "account" => %{"balance" => "50.00", "id" => _id},
        "message" => "Balance changed succesfully"
      } = response
    end

    test "when there are invalid params, return an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "propolis"}
      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid value!"}

      assert response == expected_response
    end
  end
end
