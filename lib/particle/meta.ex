defmodule Particle.Meta do
  @moduledoc false

  defstruct [:total_pages]

  @type t :: %__MODULE__{
          total_pages: integer
       }

end
