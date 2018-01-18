defmodule Poker.Supervisor do
  @moduledoc """
    Module responsible for supervising Poker genservers
  """
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(Poker.AgentDeck, [], name: Poker.AgentDeck)    
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end