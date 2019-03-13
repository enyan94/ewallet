# Copyright 2018-2019 OmiseGO Pte Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

defmodule EWallet.Bouncer.UserTarget do
  @moduledoc """
  A policy helper containing the actual authorization.
  """
  @behaviour EWallet.Bouncer.TargetBehaviour
  alias EWalletDB.User
  alias EWalletDB.Helpers.Preloader

  @spec get_owner_uuids(User.t()) :: [Ecto.UUID.t()]
  def get_owner_uuids(%User{uuid: uuid}) do
    [uuid]
  end

  @spec get_target_types() :: [atom()]
  def get_target_types, do: [:admin_users, :end_users]

  @spec get_target_type(User.t()) :: :admin_users | :end_users
  def get_target_type(%User{is_admin: true}) do
    :admin_users
  end

  def get_target_type(%User{is_admin: false}) do
    :end_users
  end

  @spec get_target_accounts(User.t(), any()) :: [Account.t()]
  def get_target_accounts(%User{is_admin: true} = target, _dispatch_config) do
    Preloader.preload(target, [:accounts]).accounts
  end

  def get_target_accounts(%User{is_admin: false} = target, _dispatch_config) do
    target = Preloader.preload(target, [:linked_accounts])
    target.linked_accounts
  end
end
