defmodule Poker.CardTest do
  use ExUnit.Case
  doctest Poker.Card

  alias Poker.Card, as: Card

  test "check all card parsed" do
    assert Card.parse_card("2C") == {2, 2, :C}        
    assert Card.parse_card("3C") == {3, 3, :C}
    assert Card.parse_card("4C") == {4, 4, :C}
    assert Card.parse_card("5C") == {5, 5, :C}
    assert Card.parse_card("6C") == {6, 6, :C}
    assert Card.parse_card("7C") == {7, 7, :C}
    assert Card.parse_card("8C") == {8, 8, :C}
    assert Card.parse_card("9C") == {9, 9, :C}
    assert Card.parse_card("TC") == {:T, 10, :C}
    assert Card.parse_card("JC") == {:J, 11, :C}
    assert Card.parse_card("QC") == {:Q, 12, :C}
    assert Card.parse_card("KC") == {:K, 13, :C}
    assert Card.parse_card("AC") == {:A, 14, :C}
    assert Card.parse_card("2D") == {2, 2, :D}
    assert Card.parse_card("3D") == {3, 3, :D}
    assert Card.parse_card("4D") == {4, 4, :D}
    assert Card.parse_card("5D") == {5, 5, :D}
    assert Card.parse_card("6D") == {6, 6, :D}
    assert Card.parse_card("7D") == {7, 7, :D}
    assert Card.parse_card("8D") == {8, 8, :D}
    assert Card.parse_card("9D") == {9, 9, :D}
    assert Card.parse_card("TD") == {:T, 10, :D}
    assert Card.parse_card("JD") == {:J, 11, :D}
    assert Card.parse_card("QD") == {:Q, 12, :D}
    assert Card.parse_card("KD") == {:K, 13, :D}
    assert Card.parse_card("AD") == {:A, 14, :D}
    assert Card.parse_card("2H") == {2, 2, :H}
    assert Card.parse_card("3H") == {3, 3, :H}
    assert Card.parse_card("4H") == {4, 4, :H}
    assert Card.parse_card("5H") == {5, 5, :H}
    assert Card.parse_card("6H") == {6, 6, :H}
    assert Card.parse_card("7H") == {7, 7, :H}
    assert Card.parse_card("8H") == {8, 8, :H}
    assert Card.parse_card("9H") == {9, 9, :H}
    assert Card.parse_card("TH") == {:T, 10, :H}
    assert Card.parse_card("JH") == {:J, 11, :H}
    assert Card.parse_card("QH") == {:Q, 12, :H}
    assert Card.parse_card("KH") == {:K, 13, :H}
    assert Card.parse_card("AH") == {:A, 14, :H}
    assert Card.parse_card("2S") == {2, 2, :S}
    assert Card.parse_card("3S") == {3, 3, :S}
    assert Card.parse_card("4S") == {4, 4, :S}
    assert Card.parse_card("5S") == {5, 5, :S}
    assert Card.parse_card("6S") == {6, 6, :S}
    assert Card.parse_card("7S") == {7, 7, :S}
    assert Card.parse_card("8S") == {8, 8, :S}
    assert Card.parse_card("9S") == {9, 9, :S}
    assert Card.parse_card("TS") == {:T, 10, :S}
    assert Card.parse_card("JS") == {:J, 11, :S}
    assert Card.parse_card("QS") == {:Q, 12, :S}
    assert Card.parse_card("KS") == {:K, 13, :S}
    assert Card.parse_card("AS") == {:A, 14, :S}
  end

  test "wrong card" do
    assert Card.parse_card("XX") == {"XX", 0, ""}
  end

  test "check all values of the cards" do
    assert Card.card_value(2) == 2
    assert Card.card_value(3) == 3
    assert Card.card_value(4) == 4
    assert Card.card_value(5) == 5
    assert Card.card_value(6) == 6
    assert Card.card_value(7) == 7
    assert Card.card_value(8) == 8
    assert Card.card_value(9) == 9
    assert Card.card_value(:T) == 10
    assert Card.card_value(:J) == 11
    assert Card.card_value(:Q) == 12
    assert Card.card_value(:K) == 13
    assert Card.card_value(:A) == 14
  end
end
