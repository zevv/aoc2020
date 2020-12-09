import strutils, sequtils, math

var part1, part2: int
var vs: seq[int]
let n = 25

proc isSum(v: int): bool =
  if vs.len < n:
    return true
  for i in vs.len-n ..< vs.len:
    for j in vs.len-n ..< i:
      if v == vs[i] + vs[j]:
        return true

for l in lines("input"):
  let v = l.parseInt
  if not isSum(v):
    part1 = v
  vs.add v

block done:
  for l in 2..<vs.len:
    for i in 0..<vs.len-l:
      let r = vs[i..<i+l]
      if r.sum == part1:
        part2 = r.min + r.max
        break done

echo "part1: ", part1
echo "part2: ", part2
