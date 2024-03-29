defmodule RocketpayWeb.AccountsController do
  use RocketpayWeb, :controller

  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse
  alias Rocketpay.Account

  action_fallback RocketpayWeb.FallbackController

  def deposit(conn, params) do
    with {:ok, %Account{} = account} <- Rocketpay.deposit(params) do
    conn
    |> put_status(:ok)
    |> render("update.json", account: account)
    end
  end

  def withdraw(conn, params) do
    with {:ok, %Account{} = account} <- Rocketpay.withdraw(params) do
    conn
    |> put_status(:ok)
    |> render("update.json", account: account)
    end
  end

  def transaction(conn, params) do
    task = Task.async(fn -> Rocketpay.transaction(params) end)




    with {:ok, %TransactionResponse{} = transaction} <- Task.await(task) do
    conn
    |> put_status(:ok)
    |> render("transaction.json", transaction: transaction)
    end
  end
end
