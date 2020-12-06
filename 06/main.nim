import npeg, sequtils

var answer: set[char]
var answers: seq[set[char]]
var part1, part2 = 0

let p = peg groups:
  answer <- Alpha:
    answer.incl ($0)[0]
  person <- +answer * '\n':
    answers.add answer
    answer = {}
  group <- +person * ('\n' | !1):
    part1 += answers.foldl(a + b).len
    part2 += answers.foldl(a * b).len
    answers.setlen(0)
  groups <- +group:
    echo "part1: ", part1
    echo "part2: ", part2

discard p.matchFile("input")
