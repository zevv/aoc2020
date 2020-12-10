import strutils, sequtils, tables, algorithm, math

var
  vs: seq[int]
  d1, d3: int
  ts: Table[int, int]

vs.add 0
for l in lines("input"):
  vs.add parseInt(l)
vs.add vs.max+3
vs.sort

for i in 1..<vs.len:
  let d = vs[i] - vs[i-1]
  if d == 1: inc d1
  if d == 3: inc d3

ts[0] = 1
for v in vs[1 .. ^1]:
  ts[v] = toSeq(v-3..v-1).
          mapIt(ts.getOrDefault(it)).
          sum

echo "part1: ", (d1 * d3)
echo "part2: ", ts[vs.max]
