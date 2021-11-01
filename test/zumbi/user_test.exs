defmodule Zumbi.UserTest do
  use Zumbi.DataCase

  alias Zumbi.User

  describe "survivors" do
    alias Zumbi.User.Survivor

    import Zumbi.Factory

    test "list_survivors/0 returns all survivors" do
      survivor = insert(:survivor)
      assert [subject] = User.list_survivors()
      assert subject.id == survivor.id
    end

    test "get_survivor!/1 returns the survivor with given id" do
      survivor = insert(:survivor)
      assert subject = User.get_survivor!(survivor.id)
      assert subject.id == survivor.id
    end

    test "create_survivor/1 with valid data creates a survivor" do
      expected = params_for(:survivor)

      assert {:ok, %Survivor{} = survivor} = User.create_survivor(expected)
      assert survivor.gender == expected.gender
      assert survivor.is_infected == expected.is_infected
      assert survivor.last_location == expected.last_location
      assert survivor.name == expected.name
    end

    test "create_survivor/1 with invalid data returns error changeset" do
      params = params_for(:survivor, %{
        gender: "K",
        name: "oi",
        last_location: nil,
        is_infected: nil
      })
      assert {:error, changeset} = User.create_survivor(params)
      assert changeset.errors[:name] |> elem(0) =~ "should be at least"
      assert changeset.errors[:gender] |> elem(0) =~ "is invalid"
    end

    test "update_survivor/2 with valid data updates the survivor" do
      survivor = insert(:survivor)
      updated = params_for(:survivor,
        %{
          name: "osamu",
          gender: "M",
          last_location: "mikado",
          is_infected: true,
          inventory: %{}
      })

      assert {:ok, %Survivor{} = survivor} = User.update_survivor(survivor, updated)
      assert survivor.gender == updated.gender
      assert survivor.last_location == updated.last_location
      assert survivor.is_infected == updated.is_infected
      assert survivor.name == updated.name
    end

    test "update_survivor/2 with invalid data returns error changeset" do
      survivor = insert(:survivor)
      params = %{
        name: nil,
        gender: nil,
        last_location: nil,
        is_infected: nil
      }

      assert {:error, %Ecto.Changeset{}} = User.update_survivor(survivor, params)
      assert survivor == User.get_survivor!(survivor.id)
    end

    test "delete_survivor/1 deletes the survivor" do
      survivor = insert(:survivor)
      assert {:ok, %Survivor{}} = User.delete_survivor(survivor)
      assert_raise Ecto.NoResultsError, fn -> User.get_survivor!(survivor.id) end
    end

    test "change_survivor/1 returns a survivor changeset" do
      survivor = insert(:survivor)
      assert %Ecto.Changeset{} = User.change_survivor(survivor)
    end
  end
end
