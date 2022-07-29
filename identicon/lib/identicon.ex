defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @doc """
  Main method for taking a string input and produce image from it and save the image data into disk under the file type .png
  """
  def generate(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)

  end

  def save_image(image_binary, input) do
    File.write("#{input}.png", image_binary)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
      pixel_map = Enum.map grid, fn({_, idx}) ->
                        x = rem(idx, 5) * 50
                        y = div(idx, 5) * 50
                        top_left = {x, y}
                        bottom_right = {x + 50, y + 50}

                        {top_left, bottom_right}
                  end

      %Identicon.Image{image | pixel_map: pixel_map}
   end
 
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
      grid = Enum.filter grid, fn({code, _}) ->
        rem(code, 2) == 0
      end

      %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = 
        hex
        |> Enum.chunk_every(3, 3, :discard)
        |> Enum.map(&mirror_row/1)
        |> List.flatten
        |> Enum.with_index

    %Identicon.Image{image | grid: grid}   
  end

  def mirror_row([first, second | _] = row) do
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
          |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

end
