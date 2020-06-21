defmodule AVLTreeTest do
  use ExUnit.Case

    test "test parser" do
      tree = ~s(
                        6
                  /            \\
              3                  10
                \\             /    \\
                  4          8       12
                            /         / \\
                           7        11   13
      )
      assert parse_tree(tree) == AVLTree.empty() |> AVLTree.add(6) |> AVLTree.add(3)  |> AVLTree.add(10)
      |> AVLTree.add(4) |> AVLTree.add(8) |> AVLTree.add(12)
      |> AVLTree.add(7) |> AVLTree.add(11) |> AVLTree.add(13)
    end

    test "add without rebalancing required" do
      before = ~s(
                        6
                  /            \\
              3                  10
                \\             /    \\
                   4          8       12
                            /         / \\
                           7        11   13
      )
      expected = ~s(
                        6
                  /            \\
              3                  10
           /    \\             /    \\
         1        4           8       12
                            /         / \\
                           7        11   13
      )
      assert parse_tree(before) |> AVLTree.add(1) == parse_tree(expected)
    end

    test "add with leaf rebalancing" do
      before = ~s(
                        6
                  /            \\
              3                  10
                \\              /    \\
                   4          9       12
                            /         / \\
                           8        11   13
      )
      expected = ~s(
                        6
                  /            \\
              3                  10
                \\             /    \\
                   4          8       12
                            /   \\     / \\
                           7     9  11   13
      )
      assert parse_tree(before) |> AVLTree.add(7) == parse_tree(expected)
    end

    test "add with internal node rebalancing" do
      before = ~s(
                        6
                  /            \\
              3                  10
                \\             /    \\
                   4          9       13
                            /         / \\
                           8        11   14
      )
      expected = ~s(
                        10
                  /            \\
              6                  13
           /     \\             /     \\
          3        9          11      14
            \\    /             \\
              4 8               12

      )
      assert parse_tree(before) |> AVLTree.add(12) == parse_tree(expected)
    end

    defp parse_tree(tree) do
      values = tree
      |> String.split("\n")
      |> Enum.drop_every(2)
      |> Enum.flat_map(& Regex.split(~r/[[:blank:]]/, &1))
      |> Enum.filter(& byte_size(&1) != 0)
      |> Enum.map(fn value -> case Integer.parse(value) do
        {parsed, _} -> parsed
        _ -> nil
      end
      end)
      |> Enum.filter(& &1 != nil)
      Enum.reduce(values, AVLTree.empty(), &AVLTree.add(&2, &1))
    end

end
