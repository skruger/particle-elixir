defmodule Particle.Products.Customer do
  @moduledoc false

  defstruct [:id, :username, :activation_code]

  @type t :: %__MODULE__{
          id: string,
          username: string,
          activation_code: string
       }

end
