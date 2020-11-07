defmodule Particle.Products.Devices do
  @moduledoc false
  alias Particle.Base
  #alias Particle.Error

  defstruct [:devices, :customers, :meta]

  @type t :: %__MODULE__{
          devices: [%Particle.Device{}],
          customers: [%Particle.Products.Customer{}],
          meta: [%Particle.Meta{}],
       }

  def get(product) do
    path = "products/#{product}/devices"
    Base.get(path, __MODULE__)
  end

end

defmodule Particle.Products.Device do
  @moduledoc false
  alias Particle.Base

  def get(product_id, device_id) do
    path = "products/#{product_id}/devices/#{device_id}"
    Base.get(path, %Particle.Device{})
  end

end
