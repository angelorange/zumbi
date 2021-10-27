defmodule Zumbi.Factory do
  use ExMachina.Ecto, repo: Zumbi.Repo

  use Zumbi.SurvivorFactory
end
