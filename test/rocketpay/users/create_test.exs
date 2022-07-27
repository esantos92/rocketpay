defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.Users.Create
  alias Rocketpay.User

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Pedro Sampaio",
        password: "quero12345",
        nickname: "DjPedro",
        email: "pedro.sampaio@email.com",
        age: "30"
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Pedro Sampaio", age: 30, id: ^user_id} = user
    end

    test "when there are invalid paramas, returns an error" do
      params = %{
        name: "Pedro Sampaio",
        password: "quer",
        nickname: "DjPedro",
        email: "pedro.sampaio@email.com",
        age: "15"
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(changeset)  == expected_response
    end
  end
end
