import npeg, strutils, sequtils

var part1, part2: int

let p = peg lines:
  lines <- +line
  line <- >+Digit * "-" * >+Digit * " " * >Alpha * ": " * >+Alpha * '\n':
    let (v1, v2, letter, pwd) = (parseInt($1), parseInt($2), ($3)[0], $4)

    if pwd.countIt(it == letter) in v1..v2:
      inc part1

    if pwd[v1-1] == letter xor pwd[v2-1] == letter:
      inc part2

if p.matchfile("input").ok:
  echo "part1: ", part1
  echo "part2: ", part2
