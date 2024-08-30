setup() {
  load 'test_helper/common-setup'
  _common_setup

  source "$PROJECT_ROOT"/src/functions_lib.sh
}

teardown() {
  : # rm -f /tmp/bats-tutorial-project-ran
}

@test "add_two_back_slashes in sting" {
  run add_two_back_slashes "without slash"
  assert_output "without slash"

  run add_two_back_slashes "one \" slash"
  assert_output "one \\\" slash"

  run add_two_back_slashes "two \"slash\""
  assert_output "two \\\"slash\\\""
}

@test "get_num_of_items for title" {
  run get_num_of_items ""
  assert_output "0"

  run get_num_of_items "item 1"
  assert_output "1"

  run get_num_of_items "item 1
  item 2"
  assert_output "2"

  run get_num_of_items "item 1
item 2
item 3
item 4
item 5"
  assert_output "5"
}

@test "check double quote in CMD" {
  run check_double_quote ""
  assert_output "0"

  run check_double_quote '"'
  assert_output "1"

  run check_double_quote 'nix flake "nixpkgs#julia"'
  assert_output "2"
}

@test "rm_tail_slash" {
  run rm_tail_slash ""
  assert_output ""

  run rm_tail_slash "/"
  assert_output ""

  run rm_tail_slash "https://castel.dev"
  assert_output "https://castel.dev"

  run rm_tail_slash "https://castel.dev/"
  assert_output "https://castel.dev"
}

@test "to_lowercase" {
  run to_lowercase ""
  assert_output ""

  run to_lowercase "TAGS"
  assert_output "tags"

  run to_lowercase "TaGs"
  assert_output "tags"

  run to_lowercase "TagS"
  assert_output "tags"

  run to_lowercase "Real-time \\\"LaTeX\\\" engine"
  assert_output "real-time \\\"latex\\\" engine"

  run to_lowercase "Tag_A, Tag_B, Tag_C"
  assert_output "tag_a, tag_b, tag_c"
}

@test "trim" {
  run trim ""
  assert_output ""

  run trim " a"
  assert_output "a"

  run trim "a "
  assert_output "a"

  run trim "  a"
  assert_output "a"

  run trim "a  "
  assert_output "a"

  run trim "  a  "
  assert_output "a"

  run trim "  ab  "
  assert_output "ab"

  run trim "  a b  "
  assert_output "a b"

  run trim "  a  b  "
  assert_output "a  b"
}
