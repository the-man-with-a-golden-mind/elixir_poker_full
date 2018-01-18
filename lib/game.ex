defmodule Poker.Game do
  @moduledoc """
    Module holding game additional functions like comparing and 
    validating hands
  """
  alias Poker.Hand, as: Hand

  @doc """
    Function responsible for the main loop in the game
  """
  def game_loop() do
    if Application.get_env(:poker, :env) != :test do
      IO.puts("NEW GAME")
      {hand1, hand2} = get_players_hands()
      IO.puts compare_hands(hand1, hand2)
      game_loop()
    end 
  end

  @spec compare_hands(%Poker.Hand{}, %Poker.Hand{}) :: String.t
  @doc """
    Function for comparasing hands between players
  """
  def compare_hands(hand1, hand2) do
    with hand_1_struct <- Hand.parse_hand(hand1),
      hand_2_struct <- Hand.parse_hand(hand2),
      {:ok, ""} <- validate_hands(hand_1_struct, hand_2_struct),
      sorted_hand_1_struct <- Hand.sort_hand(hand_1_struct),
      sorted_hand_2_struct <- Hand.sort_hand(hand_2_struct),
      matched_hand_1_struct <- Hand.match_hand(sorted_hand_1_struct),
      matched_hand_2_struct <- Hand.match_hand(sorted_hand_2_struct),
      {value_1, comp_1, name_1} <- Hand.value_matched_hand(matched_hand_1_struct),
      {value_2, comp_2, name_2} <- Hand.value_matched_hand(matched_hand_2_struct)
    do
      cond do
        value_1 > value_2 ->
          "Player 1 has won the game with: #{name_1}"
        value_1 < value_2 ->
          "Player 2 has won the game with: #{name_2}"  
        value_1 == value_2 ->
          if comp_1 > comp_2 do
            "Player 1 has won by higher card comparasion with #{name_1}"
          else
            "Player 2 has won by higher card comparasion with #{name_2}"
          end
      end
    else
      {:error, message} ->
        message
    end
  end

  @spec validate_hands(%Poker.Hand{}, %Poker.Hand{}) :: {:atom, String.t}
  @doc """
    Function responsible for validating hands
  """
  def validate_hands(hand1, hand2) do
    with {:ok, hand1, ""} <- Hand.validate_hand(hand1),
      {:ok, hand2, ""} <- Hand.validate_hand(hand2),
      :ok <- check_hands(hand1, hand2)
    do
      {:ok, ""}
    else
      {:error, hand, message} ->
        {:error, "This hand did't pass validation: #{to_string(hand)} in the reason of: #{message}"}
      :error ->
        {:error, "One of the players is cheating: #{to_string(hand1)} #{to_string(hand2)}"}
    end
  end

  # Funcion check if there are any doubles in players hands
  defp check_hands(hand1, hand2) do
    hand1_cards = hand1.cards |> Tuple.to_list
    hand2_cards = hand2.cards |> Tuple.to_list
    checker = Enum.any?(hand1_cards, fn card -> card in hand2_cards end)
    case checker do
      true ->
        :error
      false ->
        :ok
    end
  end

  # Small helper for taking dirty IO data form console
  defp get_players_hands() do
    hand1 = IO.gets("Player 1 hand:")
    hand2 = IO.gets("Player 2 hand:")
    {hand1, hand2}
  end
end