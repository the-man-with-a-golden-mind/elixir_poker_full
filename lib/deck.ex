defmodule Poker.Deck do
  @moduledoc """
    Module holding all funcions connected with deck
  """

  @spec generate_deck() :: [String.t]
  @doc """
    Function for generating deck with all poker cards
  """
  def generate_deck() do
    low_grades = 2..9 |> Enum.map(fn grade -> Integer.to_string(grade) end)
    high_grades = ["T", "J", "Q", "K", "A"]
    cards = low_grades ++ high_grades
    colors = ["C", "D", "H", "S"]
    deck = Enum.flat_map(colors, fn color ->
      Enum.map(cards, fn grade -> grade <> color end)
    end)
    deck
  end

end