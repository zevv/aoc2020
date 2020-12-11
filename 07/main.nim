
import npeg, tables, sets, strutils

type Bag = ref object
  color: string
  kids: Table[string, int]

var
  bag: Bag
  bags: Table[string, Bag]

let p = peg rules:
  rules <- +rule * !1
  rule <- container * " contain " * contains * ".\n"
  container <- bags:
    bag = Bag(color: $1)
    bags[$1] = bag
  contains <- contents * *(", " * contents) | "no other bags"
  contents <- >+Digit * " " * bags:
    bag.kids[$2] = parseInt($1)
  bags <- >(+Alpha * " " * +Alpha) * " bag" * ?"s"

if p.matchfile("input").ok:

  var part1 = ["shiny gold"].toHashSet
  for i in 1..10:
    for color, bag in bags:
      for kidColor, n in bag.kids:
        if kidColor in part1:
          part1.incl color

  proc part2(bag: Bag): int =
    inc result
    for kidColor, n in bag.kids:
      inc result, n * part2(bags[kidColor])

  echo "part1: ", part1.card
  echo "part2: ", part2(bags["shiny gold"])
