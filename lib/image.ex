defmodule Identicon.Image do
  # struct is just a map, however difference is that
    # 1- struct can define default value
    # 2- You can't add keys that are not identified
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end