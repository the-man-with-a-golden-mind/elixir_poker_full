defmodule Poker.AgentDeckTest do
  use ExUnit.Case, async: true
  doctest Poker.AgentDeck

  alias Poker.AgentDeck, as: AgentDeck

  setup_all do
    AgentDeck.start_link()
    :ok
  end

  test "check if cards are in deck" do
    cards = ["5D", "AD"]
    assert AgentDeck.cards_in_deck?(cards) == true
  end

  test "all cards does not exists in the deck" do
    cards = ["ax", "bf"]
    assert AgentDeck.cards_in_deck?(cards) == false
  end

  test "some cards does not exists in the deck" do
    cards = ["AS", "bf"]
    assert AgentDeck.cards_in_deck?(cards) == false
  end
end