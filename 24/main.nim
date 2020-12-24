import npeg, sets, tables

let ds = {
  "e":  ( +1, 0, -1), "se": (  0, 1, -1), "sw": ( -1, 1,  0),
  "w":  ( -1, 0, +1), "nw": (  0,-1, +1), "ne": ( +1,-1,  0),
}.toTable()

type
  Tile = tuple[x:int, y:int, z:int]
  Floor = HashSet[Tile]

proc `+`(a, b: Tile): Tile =
  (a.x + b.x, a.y + b.y, a.z + b.z)

proc neighbours(m: Floor, t: Tile): int =
  for _, d in ds:
    if (t+d) in m:
      inc result

proc run(m: Floor): Floor = 
  result = m
  let r = 100
  for x in -r .. r:
    for y in max(-r, -x-r) .. min(r, -x+r):
      let tile = (x, y, -x-y)
      let n = m.neighbours tile

      if tile in m and (n == 0 or n > 2):
        result.excl tile

      if tile notin m and n == 2:
        result.incl tile

var cur: Tile
var floor: Floor

let p = peg list:
  list <- +line 
  line <- +dir * '\n':
    if cur notin floor:
      floor.incl cur
    else:
      floor.excl cur
    cur.reset
  dir <- ?{'s','n'} * {'e','w'}:
    cur = cur + ds[$0]

if p.matchFile("input").ok:
  echo "part1: ", floor.card
  for i in 1..100:
    floor = floor.run
  echo "part2: ", floor.card()
