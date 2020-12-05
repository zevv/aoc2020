import parseutils, strutils, sequtils, algorithm, sets
  
proc toBit(c: char): int =
  if c in {'R','B'}: 1 else: 0

proc toId(s: string): int =
  s.foldl(a*2 or b.toBit, 0)

let vs = toSeq(lines("input")).map(toId)

echo "part1: ", vs.max()
echo "part2: ", (vs.min..vs.max).toSeq.toSet - vs.toSet
