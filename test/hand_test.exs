defmodule Poker.HandTest do
  use ExUnit.Case
  doctest Poker.Hand

  alias Poker.Hand, as: Hand

  setup_all do
    Poker.AgentDeck.start_link()
    :ok
  end

  describe "Match hands" do
    test "match hand with full house #1" do
      hand = Hand.parse_hand("6d 6c 3h 6h 3d") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:full_house, 6, []}
    end
    
    test "match hand with full house #2" do
      hand = Hand.parse_hand("3d 3c 2h 2s 3d") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:full_house, 3, []}
    end
    
    test "match hand with straight" do
      hand = Hand.parse_hand("6c 5h 3c 4c 2h") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:straight, 6, []}
    end
    
    test "match hand with full straight" do
      hand = Hand.parse_hand("6c 5c 3c 4c 2c") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:straight_flush, 6, []}
    end
    
    test "match hand with four of a kind #1" do
      hand = Hand.parse_hand("6c 6d 6h 6s 2c") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:four_of_a_kind, 6, []}
    end
    
    test "match hand with four of a kind #2" do
      hand = Hand.parse_hand("6c 6d 6h 6s 7c") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:four_of_a_kind, 6, []}
    end
    
    test "match hand with three of a kind #1" do
      hand = Hand.parse_hand("6c 6d 6h 5s 2c") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:three_of_a_kind, 6, []}
    end
    
    test "match hand with three of a kind #2" do
      hand = Hand.parse_hand("6c 6d 6h 7s 2c") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:three_of_a_kind, 6, []}
    end
    
    test "match hand with three of a kind #3" do
      hand = Hand.parse_hand("6c 6d 6h 7s 8c") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:three_of_a_kind, 6, []}
    end
    
    test "match hand with two pairs #1" do
      hand = Hand.parse_hand("6c 6d 4c 4d 2h") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:two_pairs, [6, 4], [2]}
    end
    
    test "match hand with two pairs #2" do
      hand = Hand.parse_hand("7c 6d 6c 3c 3h") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:two_pairs, [6, 3], [7]}
    end
    
    test "match hand with two pairs #3" do
      hand = Hand.parse_hand("7c 7d 4c 3c 3h") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:two_pairs, [7, 3], [4]}
    end
    
    test "match hand with pair #1" do
      hand = Hand.parse_hand("7c 7d 2c 4c 3h") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:pair, 7, [4, 3, 2]}
    end
    
    test "match hand with pair #2" do
      hand = Hand.parse_hand("8c 6d 6c 4c 3h") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:pair, 6, [8, 4, 3]}
    end
    
    test "match hand with pair #3" do
      hand = Hand.parse_hand("8c 6d 4c 4d 3h") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:pair, 4, [8, 6, 3]}
    end
    
    test "match hand with pair #4" do
      hand = Hand.parse_hand("8c 6d 4c 3d 3h") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:pair, 3, [8, 6, 4]}
    end
    
    test "match hand with flush" do
      hand = Hand.parse_hand("6c 8c 3c 4c 2c") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:flush, 8, [6, 4, 3, 2]}
    end

    test "match hand with high card" do
      hand = Hand.parse_hand("6c 8d 3c 4c 2c") |> Hand.sort_hand
      assert Hand.match_hand(hand) == {:high_card, 8, [6, 4, 3, 2]}
    end
  end

  describe "Value hands" do
    test "value high card" do
      hand = Hand.parse_hand("6c 8d 3c 4c 2c") 
        |> Hand.sort_hand 
        |> Hand.match_hand
      assert Hand.value_matched_hand(hand) == {8, [6, 4, 3, 2], "High card"}
    end

    test "value flush" do
      hand = Hand.parse_hand("6c 8c 3c 4c 2c") 
        |> Hand.sort_hand
        |> Hand.match_hand 
      assert Hand.value_matched_hand(hand) == {5008, [6, 4, 3, 2], "Flush"}
    end

    test "value full house" do
      hand = Hand.parse_hand("6d 6c 3h 6h 3d") 
        |> Hand.sort_hand
        |> Hand.match_hand 
      assert Hand.value_matched_hand(hand) == {6006, [], "Full house"}
    end

    test "value pair" do
      hand = Hand.parse_hand("6d 6c 5h 8h 3d") 
        |> Hand.sort_hand
        |> Hand.match_hand 
      assert Hand.value_matched_hand(hand) == {1006, [8, 5, 3], "Pair"}
    end

    test "value two pairs" do
      hand = Hand.parse_hand("6d 6c 3h 8h 8d") 
        |> Hand.sort_hand
        |> Hand.match_hand 
      assert Hand.value_matched_hand(hand) == {2000, [8, 6, 3], "Two Pairs"}
    end

    test "value three of a kind" do
      hand = Hand.parse_hand("6d 6c 6h 3h 8d") 
        |> Hand.sort_hand
        |> Hand.match_hand 
      assert Hand.value_matched_hand(hand) == {3006, [], "Three of a kind"}
    end

    test "value four of a kind" do
      hand = Hand.parse_hand("6d 6c 6h 6h 8d") 
        |> Hand.sort_hand
        |> Hand.match_hand 
      assert Hand.value_matched_hand(hand) == {7006, [], "Four of a kind"}
    end

    test "value streight" do
      hand = Hand.parse_hand("8d 7c 6h 5h 4d") 
        |> Hand.sort_hand
        |> Hand.match_hand 
      assert Hand.value_matched_hand(hand) == {4008, [], "Straight"}
    end
  end

  describe "validate hand" do
    test "validate short hand" do
      hand = %Poker.Hand{cards: {{8, 8, :D}}}
      assert Poker.Hand.validate_hand(hand) == {:error, hand, "Size of the hand 8D is wrong."}
    end

    test "validate to long hand" do
      hand = %Poker.Hand{cards: {{7, 7, :D}, {8, 8, :D}, {3, 3, :D}, {2, 2, :D}, {9, 9, :D}, {4, 4, :D}}}
      assert Poker.Hand.validate_hand(hand) == {:error, hand, "Size of the hand 7D 8D 3D 2D 9D 4D is wrong."}
    end

    test "validate right sized hand" do
      hand = %Poker.Hand{cards: {{8, 8, :D}, {3, 3, :D}, {2, 2, :D}, {9, 9, :D}, {4, 4, :D}}}
      assert Poker.Hand.validate_hand(hand) == {:ok, hand, ""}
    end

    test "validate wrong card hand" do
      hand = %Poker.Hand{cards: {{19, 19, :D}, {3, 3, :D}, {2, 2, :D}, {9, 9, :D}, {4, 4, :D}}}
      assert Poker.Hand.validate_hand(hand) == {:error, hand, "Some of those cards 19D 3D 2D 9D 4D are not real"}
    end

    test "validate wrong hand structure" do
      hand = %Poker.Hand{cards: {{9, 9, :D}, {3, 3, :D}, {2, 2, :D}, {9, 9, :D}, {4, 4, :D}}}
      assert Poker.Hand.validate_hand(hand) == {:error, hand, "This hand have a wrong strucutre: 9D 3D 2D 9D 4D"}
    end
  end
end

