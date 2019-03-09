defmodule Identicon do

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  # pattern matching in arguments you could not " = argument" if you don't need to use this arg
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    # egd from erlang create image in memory only  not save in hard desk
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    # fn(square)
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = 
      hex
      |> Enum.chunk_every(3, 3, :discard)
      # in ruby array.map(&method(:mirrow_row))
      # & here we are referecing if we are using mirror_row straight forward will give error
      # |> Enum.map(mirror_row) #>> compilation error en hwa by7awel y call mirrow_row with 0 arguments
      # /1 we need mirrow_row method with the one argument
      |> Enum.map(&mirror_row/1)
      # flatten 3shan lma a looop yb2a mra wa7da msh loop inside loop
      |> List.flatten
      |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  # def pick_color(image) do
  #   # this is wrong as you can't access elements in list by their index
  #   # red = image.hex[0] >> wrong
  #   # {_response, red} = Enum.fetch(image.hex, 0) >> not the best one
  #   # -------------
  #   # %Identicon.Image{hex: hex_list} = image
  #   # [r, g, b] = hex_list >> error 3shan el list feha 15 elements
  #   # [r, g, b | _tail] = hex_list
  #   # return [r, g, b]
  #   %Identicon.Image{hex: [r, g, b | _rest]} = image

  #   %Identicon.Image{image | color: {r, g, b}}
  # end

  # in JS world
  # let pick_color = function(image){
  #   image.color = {
        # r: image.hex[0],
        # g: image.hex[1],
        # b: image.hex[2]
  # };
  #   return image 
  # }

  def pick_color(%Identicon.Image{hex: [r, g, b | _rest]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

end
