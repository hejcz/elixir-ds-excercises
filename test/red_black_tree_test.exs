defmodule RBTreeTest do
  use ExUnit.Case
  import RBTree
  alias RBTree.Node

  # https://www.geeksforgeeks.org/red-black-tree-set-2-insert/?ref=lbp exercise
  test "test add" do
    tree = %Node{
      color: :black,
      value: 7,
      left: %Node{value: 3, color: :black},
      right: %Node{
        value: 18,
        color: :red,
        left: %Node{
          value: 10,
          color: :black,
          left: %Node{value: 8},
          right: %Node{value: 11}
        },
        right: %Node{
          value: 22,
          color: :black,
          right: %Node{value: 26}
        }
      }
    }

    expected = %Node{
      color: :black,
      value: 10,
      left: %Node{
        value: 7,
        left: %Node{
          value: 3,
          color: :black,
          left: %Node{color: :red, value: 2},
          right: %Node{color: :red, value: 6}
        },
        right: %Node{value: 8, color: :black}
      },
      right: %Node{
        value: 18,
        color: :red,
        left: %Node{
          value: 11,
          color: :black,
          right: %Node{value: 13, color: :red}
        },
        right: %Node{
          value: 22,
          color: :black,
          right: %Node{value: 26, color: :red}
        }
      }
    }

    assert tree |> add(2) |> add(6) |> add(13) == expected
  end
end
