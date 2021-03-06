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

defmodule EWallet.CategoryPolicy do
  @moduledoc """
  The authorization policy for categories.
  """
  alias EWallet.PolicyHelper
  alias EWallet.{Bouncer, Bouncer.Permission}
  alias EWalletDB.Category

  def authorize(:create, actor, _cateogry_attrs) do
    Bouncer.bounce(actor, %Permission{action: :create, target: %Category{}})
  end

  def authorize(action, actor, target) do
    PolicyHelper.authorize(action, actor, :categories, Category, target)
  end
end
