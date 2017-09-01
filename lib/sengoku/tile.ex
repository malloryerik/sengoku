defmodule Sengoku.Tile do
  defstruct owner: nil, armies: 1, neighbors: []

  def new(neighbors) do
    %__MODULE__{neighbors: neighbors}
  end

  def initial_state do
    %{
       1 => new([2]),
       2 => new([1, 3]),
       3 => new([2, 4, 6]),
       4 => new([3, 5]),
       5 => new([4, 6]),
       6 => new([3, 5, 7, 10]),
       7 => new([6, 8, 9, 10]),
       8 => new([7, 9]),
       9 => new([7, 8, 12, 13, 14]),
      10 => new([6, 7, 11, 12]),
      11 => new([10, 12]),
      12 => new([9, 10, 11, 14, 15, 16]),
      13 => new([9, 14]),
      14 => new([9, 12, 13, 15, 16, 17, 18, 19]),
      15 => new([12, 14, 16]),
      16 => new([12, 14, 15, 17]),
      17 => new([14, 16, 19, 20]),
      18 => new([14, 19]),
      19 => new([14, 17, 18, 20, 21]),
      20 => new([17, 19, 21, 24, 25, 28]),
      21 => new([19, 20, 22, 23, 24]),
      22 => new([21]),
      23 => new([21, 24]),
      24 => new([20, 21, 23, 25, 26]),
      25 => new([20, 24, 26, 28]),
      26 => new([24, 25, 27, 28]),
      27 => new([26, 28]),
      28 => new([20, 25, 26, 27, 29]),
      29 => new([28])
    }
  end
end
