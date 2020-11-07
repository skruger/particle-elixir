defmodule Particle.Products.Functions do
  alias Particle.Base

  defstruct [:id, :name, :connected, :return_value]
  @type t :: %__MODULE__{id: binary, name: binary, connected: Boolean, return_value: Integer}

  @moduledoc """
  This module defines the actions that can be taken on the Functions endpoint.
  """

  @spec post(binary, binary, binary, binary) :: {:ok, any} | Error.t()
  def post(product_id, device_id, function_name, argument) do
    path = "products/#{product_id}/devices/#{device_id}/#{function_name}"
    Base.post(path, [{:arg, argument}], __MODULE__)
  end
end
