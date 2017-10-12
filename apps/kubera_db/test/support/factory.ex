defmodule KuberaDB.Factory do
  @moduledoc """
  Factories used for testing.
  """
  use ExMachina.Ecto, repo: KuberaDB.Repo
  alias KuberaDB.User

  def user_factory do
    %User{
      username: sequence("thabaultzaa"),
      provider_user_id: sequence("provider_id"),
      metadata: %{
        "first_name" => sequence("Thibault"),
        "last_name" => sequence("Denizet")
      }
    }
  end
end
