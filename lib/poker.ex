defmodule Poker do
  @moduledoc """
    Main funstion in the game - responsible for getting user hands from IO
    and starting supervisor
  """
  use Application
  
  alias Poker.Game, as: Game

  def start(_type, _args) do
    Task.async(fn -> Game.game_loop() end) |> Task.await(:infinity)
    Poker.Supervisor.start_link
  end
end

