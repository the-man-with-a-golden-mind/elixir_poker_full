defmodule Poker.AgentDeck do
  @moduledoc """
    Module responsible for holding deck state as a global var
  """
  use Agent

  @doc """
    Function responsible for starting and initializing state of the agent
  """
  def start_link(opts \\ []) do
    Agent.start_link(fn -> Poker.Deck.generate_deck() end, name: __MODULE__)
  end

  @spec cards_in_deck?([String.t]) :: Boolean
  @doc """
    Function responsible for checking if all of the given cards are in the deck
  """
  def cards_in_deck?(cards) do
    Agent.get(__MODULE__, fn deck ->
      Enum.all?(cards, fn card -> card in deck end)
    end)
  end
end