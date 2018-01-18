defmodule Poker.Card do
  @moduledoc """
    Module responsible for handling card functions. 
    Card is represented as tuple with rank, value and color.
    Ex: As of spades whould be {:A, 14, :S}
  """

  @type card :: {:atom, Integer, :atom}

  @spec parse_card(String.t) :: card
  @doc """
    Function responsible for parsing card

  ## Examples

      iex> Poker.Card.parse_card("AS")
      {:A, 14, :S}
      iex> Poker.Card.parse_card("KC")
      {:K, 13, :C}
      iex> Poker.Card.parse_card("QD")
      {:Q, 12, :D}
      iex> Poker.Card.parse_card("JS")
      {:J, 11, :S}
      iex> Poker.Card.parse_card("TC")
      {:T, 10, :C}

  """
  def parse_card(card) do
    req = Regex.named_captures(~r/(?<value>[0-9TJQKA]*)(?<colour>[CDHS]{1})/, card)
    if req do
      colour = req |> Map.get("colour") |> String.to_atom
      value = req |> Map.get("value") |> parse_rank()
      rank = value |> card_value()
      {value, rank, colour}
    else
      {card, 0, ""}
    end
  end

  @doc """
    Function responsible to transate rank into card value
  
  ## Examples

      iex> Poker.Card.card_value(:A)
      14
      iex> Poker.Card.card_value(:Q)
      12
  """
  def card_value(:A), do: 14
  def card_value(:K), do: 13
  def card_value(:Q), do: 12
  def card_value(:J), do: 11
  def card_value(:T), do: 10
  def card_value(i) when is_integer(i) and i >= 2 and i <= 9, do: i
  def card_value(0), do: 0

  def to_string({rank, _, color}) do
    "#{rank}#{color}"
  end

  # function which take card name and return rank
  defp parse_rank("A"), do: :A
  defp parse_rank("K"), do: :K
  defp parse_rank("Q"), do: :Q
  defp parse_rank("J"), do: :J
  defp parse_rank("T"), do: :T
  defp parse_rank(""), do: 0
  defp parse_rank(str), do: String.to_integer(str)

end