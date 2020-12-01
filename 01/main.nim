
import strutils, math

var vs: seq[int]
for l in lines("input"):
  vs.add l.parseInt()

proc test(l: string, ts: openArray[int]) =
  if sum(ts) == 2020:
    echo l, prod(ts)

for i1 in 0..<vs.len:
  for i2 in 0..<i1:
    test "part1: ", [vs[i1], vs[i2]] 
    for i3 in 0..<i2:
      test "part2: ", [vs[i1], vs[i2], vs[i3]]
