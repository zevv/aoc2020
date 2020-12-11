import strutils, sequtils, hashes

type Map = seq[string]

proc `$`(m: Map): string = m.join("\n")
proc hash(m: Map): Hash = hash $m
proc inMap(m: Map, y, x: int): bool = y in 0..<m.len and x in 0..<m[0].len

proc get(m: Map, y, x: int): char =
  if m.inMap(y, x):
    result = m[y][x]

proc look(m: Map, y, x, dy, dx: int): char =
  var (y, x) = (y, x)
  while m.inMap(y, x):
    y += dy
    x += dx
    let c = m.get(y, x)
    if c in {'L','#'}:
      return c

proc run(m: Map, part: int): Map =
  result = m
  for y, l in m:
    for x, c in l:
      var n = 0
      for dy in -1..1:
        for dx in -1..1:
          if dy != 0 or dx != 0:
            if (part == 1 and m.get(y+dy, x+dx) == '#') or
               (part == 2 and m.look(y, x, dy, dx) == '#'):
              inc n
      if c == 'L' and n == 0:
        result[y][x] = '#'
      if c == '#' and n >= part + 3:
        result[y][x] = 'L'

for part in 1..2:
  var map = readFile("input")[0..^2].splitLines()
  while true:
    let map2 = map.run(part)
    if hash(map) == hash(map2):
      break
    map = map2
  echo "part", part, ": ", ($map).count('#')
