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

defmodule EWallet.Bouncer.TransactionRequestTarget do
  @moduledoc """
  A policy helper containing the actual authorization.
  """
  @behaviour EWallet.Bouncer.TargetBehaviour
  alias EWallet.Bouncer.Dispatcher
  alias EWalletDB.{Wallet, TransactionRequest}
  alias EWalletDB.Helpers.Preloader

  @spec get_owner_uuids(TransactionRequest.t()) :: [Ecto.UUID.t()]
  def get_owner_uuids(%TransactionRequest{user_uuid: user_uuid, account_uuid: account_uuid})
      when not is_nil(user_uuid) and not is_nil(account_uuid) do
    [account_uuid, user_uuid]
  end

  def get_owner_uuids(%TransactionRequest{user_uuid: user_uuid}) when not is_nil(user_uuid) do
    [user_uuid]
  end

  def get_owner_uuids(%TransactionRequest{account_uuid: account_uuid})
      when not is_nil(account_uuid) do
    [account_uuid]
  end

  @spec get_target_types() :: [atom()]
  def get_target_types do
    [:account_transaction_requests, :end_user_transaction_requests]
  end

  # account transaction consumptions
  @spec get_target_type(TransactionRequest.t()) ::
          :account_transaction_requests | :end_user_transaction_requests
  def get_target_type(%TransactionRequest{wallet: %Wallet{account_uuid: uuid} = wallet})
      when not is_nil(wallet) and not is_nil(uuid) do
    :account_transaction_requests
  end

  def get_target_type(%TransactionRequest{wallet: %Wallet{user_uuid: uuid} = wallet})
      when not is_nil(wallet) and not is_nil(uuid) do
    :end_user_transaction_requests
  end

  def get_target_type(%TransactionRequest{user_uuid: nil}) do
    :account_transaction_requests
  end

  # account transaction consumptions
  def get_target_type(%TransactionRequest{user_uuid: user_uuid}) when not is_nil(user_uuid) do
    :end_user_transaction_requests
  end

  @spec get_target_accounts(TransactionRequest.t(), any()) :: [Account.t()]
  def get_target_accounts(
        %TransactionRequest{account_uuid: account_uuid, user_uuid: user_uuid} = target,
        dispatch_config
      )
      when not is_nil(account_uuid) and not is_nil(user_uuid) do
    target = Preloader.preload(target, [:user, :account])
    [get_account(target) | get_user_accounts(target, dispatch_config)]
  end

  def get_target_accounts(%TransactionRequest{account_uuid: uuid} = target, _dispatch_config)
      when not is_nil(uuid) do
    [get_account(target)]
  end

  def get_target_accounts(%TransactionRequest{user_uuid: uuid} = target, dispatch_config)
      when not is_nil(uuid) do
    get_user_accounts(target, dispatch_config)
  end

  def get_target_accounts(_, _dispatch_config) do
    false
  end

  defp get_account(record) do
    Preloader.preload(record, :account).account
  end

  defp get_user(record) do
    Preloader.preload(record, :user).user
  end

  defp get_user_accounts(record, dispatch_config) do
    record
    |> get_user()
    |> Dispatcher.get_target_accounts(dispatch_config)
  end
end
