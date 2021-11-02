defmodule Zumbi.User do
  @moduledoc """
  The User context.
  """

  import Ecto.Query, warn: false
  alias Zumbi.Repo

  alias Zumbi.User.Survivor

  @doc """
  Returns the list of survivors.

  ## Examples

      iex> list_survivors()
      [%Survivor{}, ...]

  """
  def list_survivors do
    Repo.all(Survivor)
  end

  @doc """
  Gets a single survivor.

  Raises `Ecto.NoResultsError` if the Survivor does not exist.

  ## Examples

      iex> get_survivor!(123)
      %Survivor{}

      iex> get_survivor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survivor!(id), do: Repo.get!(Survivor, id)

  @doc """
  Creates a survivor.

  ## Examples

      iex> create_survivor(%{field: value})
      {:ok, %Survivor{}}

      iex> create_survivor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survivor(attrs \\ %{}) do
    %Survivor{}
    |> Survivor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a survivor.

  ## Examples

      iex> update_survivor(survivor, %{field: new_value})
      {:ok, %Survivor{}}

      iex> update_survivor(survivor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survivor(%Survivor{} = survivor, attrs) do
    survivor
    |> Survivor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a survivor.

  ## Examples

      iex> delete_survivor(survivor)
      {:ok, %Survivor{}}

      iex> delete_survivor(survivor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survivor(%Survivor{} = survivor) do
    Repo.delete(survivor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survivor changes.

  ## Examples

      iex> change_survivor(survivor)
      %Ecto.Changeset{data: %Survivor{}}

  """
  def change_survivor(%Survivor{} = survivor, attrs \\ %{}) do
    Survivor.changeset(survivor, attrs)
  end

  def get_survivor(id) do
    case Zumbi.Repo.get(Survivor, id) do
      %Survivor{} = survivor -> survivor
      _ -> {:error, :not_found}
    end
  end

  def mark_infected(survivor, x9) do
    case  flag_survivor(survivor, x9) do
      {:ok, neo_survivor, 5} -> update_survivor(neo_survivor, %{is_infected: true})
      {:ok, neo_survivor, _} -> {:ok, neo_survivor}
      {:error, :already_flagged} -> {:error, :already}
    end
  end

  defp flag_survivor(survivor, x9) do
    case Enum.member?(survivor.flag, x9.name) do
      false ->
        {:ok, neo_survivor} = update_survivor(survivor, %{flag: survivor.flag ++ [x9.name]})
        {:ok, neo_survivor, length(neo_survivor.flag)}
      true ->
        {:error, :already_flagged}
    end
  end

  def fair_trade?(inventory_one, inventory_two) do
    true
  end

  def execute_trade(p1, p2, %{"inventory_one" => i_one, "inventory_two" => i_two}) do

  end
end
