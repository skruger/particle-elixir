defmodule Particle.TokenServer.State do
  @moduledoc false
  defstruct particle_key: nil, client_id: nil, client_secret: nil, token: nil, token_timeout: nil
end

defmodule Particle.TokenServer do
  @moduledoc false
  use GenServer
  alias Particle.Error

  alias Particle.TokenServer.State

  def get_token() do
    GenServer.call(__MODULE__, :get_token)
  end

  def request_token(client_id, client_secret) do
    options = [{:ssl_options, [{:versions, [:"tlsv1.2", :"tlsv1.1", :tlsv1]}]}]
    params = [
      {"grant_type", "client_credentials"},
      {"client_id", client_id},
      {"client_secret", client_secret}
    ]
    body = {:form, params}
    case :hackney.request(:post, <<"https://api.particle.io/oauth/token">>, [], body, options) do
      {:ok, 500, _headers, _client} ->
        {:error, "Internal Server Error"}
      {:ok, status, headers, client} ->
        case :hackney.body(client) do
          {:ok, body} ->
            {:ok, Jason.decode!(body, keys: :atoms)}
          {:error, reason} ->
            {:error, reason}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  def start_link() do
    GenServer.start_link(__MODULE__, %State{}, name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %State{
      particle_key: Application.get_env(:particle, :particle_key),
      client_id: Application.get_env(:particle, :client_id),
      client_secret: Application.get_env(:particle, :client_secret),
      token: nil,
      token_timeout: 0
    }}
  end

  def handle_call(:get_token, from, state) do
    if state.client_id == nil && state.client_secret == nil do
      {:reply, state.particle_key, state}
    else
      if state.token_timeout > System.monotonic_time(:second) do
        {:reply, state.token, state}
      else
        GenServer.cast(__MODULE__, {:refresh_token, from})
        {:noreply, state}
      end
    end
  end
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:refresh_token, reply_to}, state) do
    case request_token(state.client_id, state.client_secret) do
      {:ok, result} ->
        new_timeout = System.monotonic_time(:second) + result[:expires_in] - 60
        new_token = result[:access_token]
        GenServer.reply(reply_to, {:ok, new_token})
        {:noreply, %{state | token: new_token, token_timeout: new_timeout}}
      {:error, reason} ->
        GenServer.reply(reply_to, {:error, reason})
        {:noreply, state}
    end
  end
end
