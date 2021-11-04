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

  def fair_trade?(deal_a, deal_b) do
    calc_points(deal_a) == calc_points(deal_b)
  end

  defp calc_points(deal) do
    valor = %{
      "fiji_water" =>  14,
      "campbell_soup" => 12,
      "first_aid_pouch" => 10,
      "ak47" => 8
    }

    Enum.reduce(deal, 0, fn {k, v}, acc ->
      (valor[k] * v) + acc
    end)
  end

  def execute_trade(p1, p2, %{"deal_one" => d_one, "deal_two" => d_two}) do
    survivor_one = update_inventory(p1, d_one, d_two)
    survivor_two = update_inventory(p2, d_two, d_one)

    {:ok, [survivor_one, survivor_two]}
  end

  defp update_inventory(%{inventory: bag} = survivor, minus, plus) do
    fun = fn map, mapa, k -> Map.get(map, k, 0) - Map.get(mapa, k, 0) end

    invt = %{
      fiji_water:  bag.fiji_water + fun.(plus, minus, "fiji_water"),
      first_aid_pouch:  bag.first_aid_pouch + fun.(plus, minus, "first_aid_pouch"),
      campbell_soup:  bag.campbell_soup + fun.(plus, minus, "campbell_soup"),
      ak47:  bag.ak47 + fun.(plus, minus, "ak47")
    }

    {:ok, survivor} = update_survivor(survivor, %{inventory: invt})
    survivor
  end

  def get_total_infected(), do: get_infected() |> length()

  def get_total_non_infected() do
    Survivor
    |> where([s], s.is_infected == false)
    |> Repo.all()
    |> length()
  end

  def get_average_item_per_survivor() do
    survivors = list_survivors()

    bags = Enum.map(survivors, fn s-> s.inventory end)

    div = survivors |> length()

    %{
      ak47: Enum.reduce(bags, 0, fn b, acc -> b.ak47 + acc end) / div,
      campbell_soup: Enum.reduce(bags, 0, fn b, acc -> b.campbell_soup + acc end) / div,
      fiji_water: Enum.reduce(bags, 0, fn b, acc -> b.fiji_water + acc end) / div,
      first_aid_pouch: Enum.reduce(bags, 0, fn b, acc -> b.first_aid_pouch + acc end) / div
    }
  end

  def get_infected do
    Survivor
    |> where([s], s.is_infected == true)
    |> Repo.all()
  end

  def lost_points() do
    bags = get_infected() |> Enum.map(fn s-> s.inventory end)

     total_bags =
       %{
        ak47: Enum.reduce(bags, 0, fn b, acc -> b.ak47 + acc end),
        campbell_soup: Enum.reduce(bags, 0, fn b, acc -> b.campbell_soup + acc end),
        fiji_water: Enum.reduce(bags, 0, fn b, acc -> b.fiji_water + acc end),
        first_aid_pouch: Enum.reduce(bags, 0, fn b, acc -> b.first_aid_pouch + acc end)
        }

      valor = %{
        fiji_water: 14,
        campbell_soup: 12,
        first_aid_pouch: 10,
        ak47: 8
      }

      Enum.reduce(total_bags, 0, fn {k, v}, acc ->
        (valor[k] * v) + acc
      end)
  end
end
