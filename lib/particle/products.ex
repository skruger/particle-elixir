defmodule Particle.Products do
  require Logger
  alias Particle.Base
  alias Particle.Error

  defstruct [:products]

  @type t :: %__MODULE__{
          products: [%Particle.Product{}]
       }
  @endpoint "products"

  @moduledoc """
  This module defines the actions that can be taken on the Products endpoint
  """

  @spec get :: {:ok, t} | Error.t()
  def get do
    Base.get(@endpoint, __MODULE__)
  end
end
