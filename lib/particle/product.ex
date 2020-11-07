defmodule Particle.Product.Single do
  @moduledoc false
  defstruct [:product]
  @type t :: %__MODULE__{
          product: Particle.Product
       }
end

defmodule Particle.Product do
  alias Particle.Base
  alias Particle.Error

  @moduledoc false
  defstruct [:id, :platform_id, :name, :slug, :description, :subscription_id,
    :mb_limit, :user, :groups, :settings
  ]

  @type t :: %__MODULE__{
          id: integer,
          platform_id: integer,
          name: binary,
          slug: binary,
          description: binary,
          subscription_id: integer,
          mb_limit: integer,
          user: binary,
          groups: [binary],
          settings: %{Atom => binary}
        }

  @endpoint "products"

  @spec get(binary) :: {:ok, t} | Error.t()
  def get(product_id) do
    case Base.get(@endpoint, product_id, Particle.Product.Single) do
      {:ok, result} ->
        result.product
      err ->
        err
    end
  end
end
