defmodule Sengoku.GameServer do
  use GenServer

  alias Sengoku.Game

  def new(mode) do
    game_id = random_token(7)
    start_link(game_id, mode)
    {:ok, game_id}
  end

  def start_link(game_id, mode) do
    GenServer.start_link(__MODULE__, {game_id, mode})
  end

  def init({game_id, mode}) do
    case Registry.register(:game_server_registry, game_id, :ok) do
      {:ok, _pid} -> {:ok, game_id}
      {:error, reason} -> {:error, reason}
    end
    {:ok, Game.initial_state(mode)}
  end

  # API

  def authenticate_player(game_id, token) do
    GenServer.call(via_tuple(game_id), {:authenticate_player, token})
  end

  def action(game_id, player_id, %{type: _type} = action) do
    GenServer.call(via_tuple(game_id), {:action, player_id, action})
  end

  def get_state(game_id) do
    GenServer.call(via_tuple(game_id), :get_state)
  end

  # Server

  def handle_call({:authenticate_player, token}, _from, state) do
    case Game.authenticate_player(state, token) do
      {:ok, {player_id, token}, new_state} ->
        {:reply, {:ok, player_id, token}, new_state}
      {:error, error} ->
        {:reply, {:error, error}, state}
    end
  end

  def handle_call({:action, player_id, %{type: "start_game"}}, _from, state) do
    new_state = Game.start_game(state)
    {:reply, new_state, new_state}
  end
  def handle_call({:action, player_id, %{type: "end_turn"}}, _from, %{current_player_id: player_id} = state) do
    new_state = Game.end_turn(state)
    {:reply, new_state, new_state}
  end
  def handle_call({:action, player_id, %{type: "place_army", tile_id: tile_id}}, _from, %{current_player_id: player_id} = state) do
    new_state = Game.place_army(state, tile_id)
    {:reply, new_state, new_state}
  end
  def handle_call({:action, player_id, %{type: "attack", from_id: from_id, to_id: to_id}}, _from, %{current_player_id: player_id} = state) do
    new_state = Game.attack(state, from_id, to_id)
    {:reply, new_state, new_state}
  end
  def handle_call({:action, player_id, _action}, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  defp via_tuple(game_id) do
    {:via, Registry, {:game_server_registry, game_id}}
  end

  defp random_token(length) do
    length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
