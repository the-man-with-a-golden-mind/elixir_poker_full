defmodule Poker.Hand do
  alias Poker.Card, as: Card

  require Logger

  defstruct [:cards]

  @type card :: {:atom, Integer, :atom}
  
  @typedoc """
    This type is responsible for handling state of a matched hand.
    Atom name of a hand combination:
      :high_card, :pair, :two_pairs, :three_of_a_kind, 
      :four_of_a_kind, full_house, :streight, :flush, 
      :straight_flush
  """
  @type matched_hand :: {:atom, Integer | Integer, [Integer]}

  @typedoc """
    This type is responsible for handling valuated hand state
    It is represented as a tuple of a size: 2
    First integer is representing a value and the second one
    is for list of integer to compare (if there would be tie)
  """
  @type valuated_hand :: {Integer, [Integer]}

  @spec parse_hand(String.t) :: %Poker.Hand{}
  @doc """
    Function responsible for parsing hand into proper Hand struct
  """
  def parse_hand(hand) do
    cards = hand 
      |> String.trim("\r\n")
      |> String.upcase()
      |> String.split(" ")
      |> Enum.map(fn card -> Card.parse_card(card) end)
      |> List.to_tuple
    %Poker.Hand{cards: cards}
  end

  @spec validate_hand(%Poker.Hand{}) :: {:atom, %Poker.Hand{}, String.t}
  @doc """
    Function responsible for validating hand
  """
  def validate_hand(hand) do
    with {:ok, ""} <- validate_hand_length(hand),
      {:ok, ""} <- validate_hand_cards(hand),
      {:ok, ""} <- validate_hand_structure(hand)
    do
      {:ok, hand, ""}
    else
      {:error, :err_wrong_hand_size} ->
        {:error, hand, "Size of the hand #{to_string(hand)} is wrong."}
      {:error, :err_wrong_hand_cards} ->
        {:error, hand, "Some of those cards #{to_string(hand)} are not real"}
      {:error, :err_wrong_hand_structure} ->
        {:error, hand, "This hand have a wrong strucutre: #{to_string(hand)}"}
    end
  end
  
  defimpl String.Chars, for: Poker.Hand do
    def to_string(hand) do
      hand.cards 
        |> Tuple.to_list
        |> Enum.map(fn card -> Card.to_string(card) end)
        |> Enum.join(" ")
    end
  end

  @spec value_matched_hand(matched_hand) :: valuated_hand
  @doc """
  Function responsible for count value of a player hand
  
  ## Examples
  
  iex>Poker.Hand.value_matched_hand({:pair, 8, [4, 3, 2]})
  {1008, [4, 3, 2], "Pair"}
  """
  def value_matched_hand(hand) do
    case hand do
      {:pair, a, [b, c, d]} -> {1000 + a, [b, c, d], "Pair"}
      {:two_pairs, [a, b], [c]} -> {2000, [a, b ,c], "Two Pairs"}
      {:three_of_a_kind, a, []} -> {3000 + a, [], "Three of a kind"}
      {:straight, a, []} -> {4000 + a, [], "Straight"}
      {:flush, a, [b, c, d, e]} -> {5000 + a, [b, c, d, e], "Flush"}
      {:full_house, a, []} -> {6000 + a, [], "Full house"}
      {:four_of_a_kind, a, []} -> {7000 + a, [], "Four of a kind"}
      {:straight_flush, a, []} -> {8000 + a, [], "Straight flush"}
      {:high_card, a, [b, c, d, e]} -> {a, [b, c, d, e], "High card"}
    end
  end
  

  @spec match_hand(%Poker.Hand{}) :: matched_hand
  @doc """
    Function is responsible for matching hand with poker rules
  """
  def match_hand(%Poker.Hand{cards: cards}) do
    case cards do
      {{_, a, _}, {_, a, _}, {_, a, _}, {_, b, _}, {_, b, _}} -> {:full_house, a, []}
      {{_, b, _}, {_, b, _}, {_, a, _}, {_, a, _}, {_, a, _}} -> {:full_house, a, []}
      {{_, a, _}, {_, a, _}, {_, a, _}, {_, a, _}, {_, b, _}} -> {:four_of_a_kind, a, []}
      {{_, b, _}, {_, a, _}, {_, a, _}, {_, a, _}, {_, a, _}} -> {:four_of_a_kind, a, []}
      {{_, a, _}, {_, a, _}, {_, a, _} ,{_, _, _}, {_, _, _}} -> {:three_of_a_kind, a, []}
      {{_, _, _}, {_, a, _}, {_, a, _}, {_, a, _}, {_, _, _}} -> {:three_of_a_kind, a, []}
      {{_, _, _}, {_, _, _}, {_, a, _}, {_, a, _}, {_, a, _}} -> {:three_of_a_kind, a, []}
      {{_, a, _}, {_, a, _}, {_, b, _}, {_, b, _}, {_, c, _}} -> {:two_pairs, [a, b], [c]}
      {{_, a, _}, {_, a, _}, {_, c, _}, {_, b, _}, {_, b, _}} -> {:two_pairs, [a, b], [c]}
      {{_, c, _}, {_, a, _}, {_, a, _}, {_, b, _}, {_, b, _}} -> {:two_pairs, [a, b], [c]}
      {{_, a, _}, {_, a, _}, {_, b, _}, {_, c, _}, {_, d, _}} -> {:pair, a, [b, c, d]}
      {{_, b, _}, {_, a, _}, {_, a, _}, {_, c, _}, {_, d, _}} -> {:pair, a, [b, c, d]}
      {{_, b, _}, {_, c, _}, {_, a, _}, {_, a, _}, {_, d, _}} -> {:pair, a, [b, c, d]}
      {{_, b, _}, {_, c, _}, {_, d, _}, {_, a, _}, {_, a, _}} -> {:pair, a, [b, c, d]}
      {{_, v1, q1}, {_, v2, q1}, {_, v3, q1}, {_, v4, q1}, {_, v5, q1}} ->
        hand_list = [v1, v2, v3, v4, v5]
        if consecutive?([v1, v2, v3, v4, v5]) do
          {:straight_flush, v1, []}
        else
          {:flush, v1, [v2, v3, v4, v5]}
        end
      {{_, v1, q1}, {_, v2, q2}, {_, v3, q3}, {_, v4, q4}, {_, v5, q5}} -> 
        hand_list = [v1, v2, v3, v4, v5]
        if consecutive?([v1, v2, v3, v4, v5]) do
          {:straight, v1, []}
        else
          {:high_card, v1, [v2, v3, v4, v5]}
        end
    end
  end
      
  @spec sort_hand(%Poker.Hand{}) :: %Poker.Hand{}
  @doc """
  Function responsible for sorting hand DESC
  
  ## Examples
  
  iex> Poker.Hand.sort_hand(%Poker.Hand{cards: {{2, 2, :C}, {8, 8, :H}, {3, 3, :C}, {4, 4, :D}, {5, 5, :H}}})
  %Poker.Hand{cards: {{8, 8, :H}, {5, 5, :H}, {4, 4, :D}, {3, 3, :C}, {2, 2, :C}}}
  """
  def sort_hand(%Poker.Hand{cards: cards}) do
    sorted_cards = cards
      |> Tuple.to_list
      |> Enum.sort_by(fn {_, rank, _} -> rank end)
      |> Enum.reverse
      |> List.to_tuple
    %Poker.Hand{cards: sorted_cards}
  end

  # Function responsible for checking is a list of sorted ranks in consecutive
  defp consecutive?(ranks) when is_list(ranks) do
    consecutive?(ranks, length(ranks), 0)
  end
  defp consecutive?([rank | ranks], ranks_len, acc) do
    case ranks do
      [] -> acc == ranks_len - 1
      [h|_] -> 
        if rank - h != 1, do: false, else: consecutive?(ranks, ranks_len, acc + 1)
    end
  end

  # Function is validating hand lenght
  defp validate_hand_length(%Poker.Hand{cards: cards}) do
    if cards |> Tuple.to_list |> length == 5 do
      {:ok, ""}
    else 
      {:error, :err_wrong_hand_size}
    end
  end

  # Function is validating hand structure
  defp validate_hand_structure(%Poker.Hand{cards: cards}) do
    cards_list = cards |> Tuple.to_list
    if length(Enum.uniq(cards_list)) == length(cards_list) do
      {:ok, ""}
    else
      {:error, :err_wrong_hand_structure}
    end
      
  end

  # Function is validating hand cards (if they are part of the deck)
  defp validate_hand_cards(%Poker.Hand{cards: cards}) do
    norm_cards = Enum.map(cards |> Tuple.to_list, fn card -> Card.to_string(card) end)
    case Poker.AgentDeck.cards_in_deck?(norm_cards) do
      true -> {:ok, ""}
      false -> {:error, :err_wrong_hand_cards}
    end
  end
end