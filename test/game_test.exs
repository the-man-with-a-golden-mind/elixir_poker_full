defmodule Poker.GameTest do
  use ExUnit.Case
  doctest Poker.Game

  setup_all do
    Poker.AgentDeck.start_link()
    :ok
  end

  test "check player wrong chands" do
    hand1 = %Poker.Hand{cards: {{8, 8, :D}, {7, 7, :D}, {6, 6, :D}, {5, 5, :D}, {4, 4, :D}}}
    hand2 = %Poker.Hand{cards: {{8, 8, :D}, {7, 7, :C}, {6, 6, :C}, {5, 5, :C}, {4, 4, :C}}}
    {game_status, _} = Poker.Game.validate_hands(hand1, hand2)
    assert game_status == :error
  end

  test "check player fine chands" do
    hand1 = %Poker.Hand{cards: {{8, 8, :D}, {7, 7, :D}, {6, 6, :D}, {5, 5, :D}, {4, 4, :D}}}
    hand2 = %Poker.Hand{cards: {{8, 8, :C}, {7, 7, :C}, {6, 6, :C}, {5, 5, :C}, {4, 4, :C}}}
    {game_status, _} = Poker.Game.validate_hands(hand1, hand2)
    assert game_status == :ok
  end

  test "check game high cards" do
    hand1 = "kc 2s 3c 4c 5c"
    hand2 = "qc 2d 3d 4d 5d"
    result = Poker.Game.compare_hands(hand1, hand2)
    assert result == "Player 1 has won the game with: High card"
  end

  test "check game high cards comp" do
    hand1 = "kc 2s 3c 4c 5c"
    hand2 = "ks 2d 3d 4d 6d"
    result = Poker.Game.compare_hands(hand1, hand2)
    assert result == "Player 2 has won by higher card comparasion with High card"
  end

  test "check game flush " do
    hand1 = "kc 2c 3c 4c 5c"
    hand2 = "qs 2d 3d 4d 6d"
    result = Poker.Game.compare_hands(hand1, hand2)
    assert result == "Player 1 has won the game with: Flush"
  end

  test "check game flush comp " do
    hand1 = "kc 2c 3c 4c 5c"
    hand2 = "kd 2d 3d 4d 6d"
    result = Poker.Game.compare_hands(hand1, hand2)
    assert result == "Player 2 has won by higher card comparasion with Flush"
  end

  test "check game full house " do
    hand1 = "kc 2c 3c 4c 5c"
    hand2 = "6d 6c 6s 2d 2s"
    result = Poker.Game.compare_hands(hand1, hand2)
    assert result == "Player 2 has won the game with: Full house"
  end

  test "check game full comp" do
    hand1 = "3s 3d 3c 4c 4d"
    hand2 = "6d 6c 6s 2d 2s"
    result = Poker.Game.compare_hands(hand1, hand2)
    assert result == "Player 2 has won the game with: Full house"
  end

  test "check streight flush" do
    hand1 = "3s 4s 5s 6s 7s"
    hand2 = "6d 6c 6h 2d 2s"
    result = Poker.Game.compare_hands(hand1, hand2)
    assert result == "Player 1 has won the game with: Straight flush"
  end
end