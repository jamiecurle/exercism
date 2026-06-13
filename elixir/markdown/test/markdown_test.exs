defmodule MarkdownTest do
  use ExUnit.Case

  describe "to_lines" do
    test "happy path" do
      input = "# Hello\n* Item 1\n* Item 2"
      expected = ["# Hello", "* Item 1", "* Item 2"]
      assert Markdown.to_lines(input) == expected
    end
  end

  describe "block_elements" do
    test "happy path" do
      input = ["# Hello", "* Item 1", "* Item 2", "thats why we don't"]

      expected = [
        {:h1, ["Hello"]},
        {:li, ["Item 1"]},
        {:li, ["Item 2"]},
        {:p, ["thats why we don't"]}
      ]

      assert Markdown.block_elements(input) == expected
    end
  end

  describe "matching block level" do
    test "h1" do
      input = "# hello"
      output = {:h1, ["hello"]}
      assert Markdown.match_block_element(input) == output
    end

    test "h2" do
      input = "## hello"
      output = {:h2, ["hello"]}
      assert Markdown.match_block_element(input) == output
    end

    test "h3" do
      input = "### hello"
      output = {:h3, ["hello"]}
      assert Markdown.match_block_element(input) == output
    end

    test "h4" do
      input = "#### hello"
      output = {:h4, ["hello"]}
      assert Markdown.match_block_element(input) == output
    end

    test "h5" do
      input = "##### hello"
      output = {:h5, ["hello"]}
      assert Markdown.match_block_element(input) == output
    end

    test "h6" do
      input = "###### hello"
      output = {:h6, ["hello"]}
      assert Markdown.match_block_element(input) == output
    end

    test "matches paragraph" do
      input = "hello"
      output = {:p, ["hello"]}
      assert Markdown.match_block_element(input) == output
    end

    test "matches unordered list" do
      input = "* hello"
      output = {:li, ["hello"]}
      assert Markdown.match_block_element(input) == output
    end
  end

  describe "group blocks" do
    test "happy path" do
      input = [
        {:h1, ["Hello"]},
        {:li, ["Item 1"]},
        {:li, ["Item 2"]},
        {:p, ["thats why we don't"]}
      ]

      expected = [
        {:h1, ["Hello"]},
        {:li, ["Item 1", "Item 2"]},
        {:p, ["thats why we don't"]}
      ]

      assert Markdown.group_blocks(input) == expected
    end
  end

  describe "inline elements" do
    test "happy path" do
      input = [
        {:li, ["Item 1 isn't important", "but __Item 2__  _really is_"]},
        {:p, ["thats why we don't"]}
      ]

      expected = [
        {:li,
         [
           "Item 1 isn't important",
           "but",
           {:b, "Item 2"},
           {:i, "really is"}
         ]},
        {:p, ["thats why we don't"]}
      ]

      assert Markdown.inline_elements(input) == expected
    end
  end

  describe "bold" do
    test "happy path" do
      input = "but __Item 2__ _really is_"
      expected = ["but ", {:b, "Item 2"}, " _really is_"]
      assert Markdown.bold(input) == expected
    end

    test "bold doesn't parse on single underscores" do
      input = "but __Item 2__ _really is_"
      expected = ["but ", {:b, "Item 2"}, " _really is_"]
      assert Markdown.bold(input) == expected
    end
  end

  describe "italic" do
    test "happy path" do
      input = "but __Item 2__ _really is_"
      expected = ["but ", "__Item 2__", {:i, "really is"}]
      assert Markdown.italic(input) == expected
    end
  end

  # describe "tokenise test" do
  #   test "tokenise heading and list" do
  #     input = "# Hello\n* Item 1\n* Item 2"
  #     expected = [{:h1, ["Hello"]}, {:li, ["Item 1"]}, {:li, ["Item 2"]}]
  #     assert Markdown.tokenise(input) == expected
  #   end

  #   test "tokenise heading, list paragraph" do
  #     input = "# Hello\n* Item 1\n* Item 2 \n This is a paragraph."

  #     expected = [
  #       {:h1, ["Hello"]},
  #       {:li, ["Item 1"]},
  #       {:li, ["Item 2 "]},
  #       {:p, [" This is a paragraph."]}
  #     ]

  #     assert Markdown.tokenise(input) == expected
  #   end
  # end

  # @tag :pending
  test "parses normal text as a paragraph" do
    input = "This will be a paragraph"
    expected = "<p>This will be a paragraph</p>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "parsing italics" do
    input = "_This will be italic_"
    expected = "<p><em>This will be italic</em></p>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "parsing bold text" do
    input = "__This will be bold__"
    expected = "<p><strong>This will be bold</strong></p>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "mixed normal, italics and bold text" do
    input = "This will _be_ __mixed__"
    expected = "<p>This will <em>be</em> <strong>mixed</strong></p>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "with h1 header level" do
    input = "# This will be an h1"
    expected = "<h1>This will be an h1</h1>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "with h2 header level" do
    input = "## This will be an h2"
    expected = "<h2>This will be an h2</h2>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "with h3 header level" do
    input = "### This will be an h3"
    expected = "<h3>This will be an h3</h3>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "with h4 header level" do
    input = "#### This will be an h4"
    expected = "<h4>This will be an h4</h4>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "with h5 header level" do
    input = "##### This will be an h5"
    expected = "<h5>This will be an h5</h5>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "with h6 header level" do
    input = "###### This will be an h6"
    expected = "<h6>This will be an h6</h6>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "h7 header level is a paragraph" do
    input = "####### This will not be an h7"
    expected = "<p>####### This will not be an h7</p>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "unordered lists" do
    input = "* Item 1\n* Item 2"
    expected = "<ul><li>Item 1</li><li>Item 2</li></ul>"
    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "with a little bit of everything" do
    input = "# Header!\n* __Bold Item__\n* _Italic Item_"

    expected =
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"

    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "with markdown symbols in the header text that should not be interpreted" do
    input = "# This is a header with # and * in the text"
    expected = "<h1>This is a header with # and * in the text</h1>"

    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "with markdown symbols in the list item text that should not be interpreted" do
    input = "* Item 1 with a # in the text\n* Item 2 with * in the text"
    expected = "<ul><li>Item 1 with a # in the text</li><li>Item 2 with * in the text</li></ul>"

    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "with markdown symbols in the paragraph text that should not be interpreted" do
    input = "This is a paragraph with # and * in the text"
    expected = "<p>This is a paragraph with # and * in the text</p>"

    assert Markdown.parse(input) == expected
  end

  # @tag :pending
  test "unordered lists close properly with preceding and following lines" do
    input = "# Start a list\n* Item 1\n* Item 2\nEnd a list"
    expected = "<h1>Start a list</h1><ul><li>Item 1</li><li>Item 2</li></ul><p>End a list</p>"

    assert Markdown.parse(input) == expected
  end
end
