defmodule Poker.DeckTest do
    use ExUnit.Case
    doctest Poker.Deck

    test "check carts in deck" do
        deck = Poker.Deck.generate_deck()
        assert length(deck) == 52
        assert "2C" in deck        
        assert "3C" in deck
        assert "4C" in deck
        assert "5C" in deck
        assert "6C" in deck
        assert "7C" in deck
        assert "8C" in deck
        assert "9C" in deck
        assert "TC" in deck
        assert "JC" in deck
        assert "QC" in deck
        assert "KC" in deck
        assert "AC" in deck
        assert "2D" in deck
        assert "3D" in deck
        assert "4D" in deck
        assert "5D" in deck
        assert "6D" in deck
        assert "7D" in deck
        assert "8D" in deck
        assert "9D" in deck
        assert "TD" in deck
        assert "JD" in deck
        assert "QD" in deck
        assert "KD" in deck
        assert "AD" in deck
        assert "2H" in deck
        assert "3H" in deck
        assert "4H" in deck
        assert "5H" in deck
        assert "6H" in deck
        assert "7H" in deck
        assert "8H" in deck
        assert "9H" in deck
        assert "TH" in deck
        assert "JH" in deck
        assert "QH" in deck
        assert "KH" in deck
        assert "AH" in deck
        assert "2S" in deck
        assert "3S" in deck
        assert "4S" in deck
        assert "5S" in deck
        assert "6S" in deck
        assert "7S" in deck
        assert "8S" in deck
        assert "9S" in deck
        assert "TS" in deck
        assert "JS" in deck
        assert "QS" in deck
        assert "KS" in deck
        assert "AS" in deck
    end
end  