defmodule Cards do
  @moduledoc """
  Documentation for `Cards`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Cards.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  create a new deck of cards
  ## Examples

      # iex> Cards.create_deck()
      [{"Ten", "Clubs"}, {"Nine", "Hearts"}, {"Two", "Hearts"}, ...]
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for value <- values, suit <- suits do
        {value, suit}
    end

  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
     check to see if a deck contains a specific card or not
  ## Examples
        iex> deck = Cards.create_deck()
        iex> Cards.contains?(deck, {"Queen", "Clubs"})
        true
  """
  def contains?(deck, hand) do
    Enum.member?(deck, hand)
  end

  @doc """
  from a deck of cards, deal out a number of cards as per specified hand_size

  ## Examples

      iex> deck = Cards.create_deck()
      iex> shuffled = Cards.shuffle(deck)
      iex> {hand, rest} = Cards.deal(shuffled, 3)

      [{"Ten", "Clubs"}, {"Nine", "Hearts"}, {"Two", "Hearts"}]

  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

   def load(filename) do
    binary = File.read!(filename)
    :erlang.binary_to_term(binary)
  end

   def load2(filename) do
    #{status, binary} = File.read(filename)
    #case status do
    #   :ok -> :erlang.binary_to_term(binary)
    #   :error -> "That file does not exist!"
    #end

    # the above code could be simplified a bit more to this:
      case File.read(filename) do
       {:ok, binary} -> :erlang.binary_to_term(binary)
       {:error, _reason} -> "That file does not exist!"
    end
  end

   def deal_a_hand(hand_size) do 
    create_deck() |> shuffle |> deal(hand_size)
   end
end
