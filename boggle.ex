defmodule Boggle do

  def boggle(board, words) do
    # Convert the board from a tuple of tuples to a list of lists for easier manipulation
    board = Tuple.to_list(board) |> Enum.map(&Tuple.to_list/1)

    # Create a set of legal words for quick lookup
    word_set = MapSet.new(words)

    # Initialize the found words map to store words and their corresponding paths
    found_words = %{}

    # Iterate over each cell of the board to start word finding from every position
    found_words = 
      for i <- 0..(length(board) - 1),
          j <- 0..(length(List.first(board)) - 1),
          reduce: found_words do
        acc -> 
          # Start the DFS search from the current cell
          find_words(board, word_set, i, j, "", [], acc)
      end

    # Return the map of found words and their paths
    found_words
  end

  
  #does a DFS to find all valid words starting from the given cell.
  
  defp find_words(board, word_set, i, j, current_word, path, found_words) do
    if valid_position?(board, i, j) && {i, j} not in path do
      # Get the letter at the current position
      letter = Enum.at(Enum.at(board, i), j)
      # Form the new word by appending the current letter
      new_word = current_word <> letter
      # Add the current position to the path
      new_path = path ++ [{i, j}]

      # If the new word is in the set of legal words, add it to the found words map
      found_words = 
        if MapSet.member?(word_set, new_word) do
          Map.put(found_words, new_word, new_path)
        else
          found_words
        end

      # Recursively search all valid neighboring cells
      neighbors(i, j)
      |> Enum.reduce(found_words, fn {ni, nj}, acc ->
        find_words(board, word_set, ni, nj, new_word, new_path, acc)
      end)
    else
      found_words
    end
  end

  
  #Checks if the given position is within the board boundaries.
  
  defp valid_position?(board, i, j) do
    # Check if the row and column indices are within the bounds of the board
    i >= 0 && i < length(board) && j >= 0 && j < length(Enum.at(board, i))
  end

  
  #Returns the valid neighboring cells for a given cell position.
  
  defp neighbors(i, j) do
    [
      {i - 1, j - 1}, {i - 1, j}, {i - 1, j + 1},  # Top-left, Top, Top-right
      {i, j - 1},              {i, j + 1},        # Left, Right
      {i + 1, j - 1}, {i + 1, j}, {i + 1, j + 1}  # Bottom-left, Bottom, Bottom-right
    ]
  end
end
