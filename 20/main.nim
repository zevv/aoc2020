import npeg, tables, strutils, sequtils, math, sets

type
  Tile = object
    id: int
    edges: HashSet[string]
    used: bool
    rows: seq[string]
    neighbours: int

proc calcEdges(rows: seq[string]): seq[string] =
  result.setlen 8
  for i in 0..9:
    let j = 9-i
    result[0].add rows[0][i]
    result[1].add rows[9][i]
    result[2].add rows[i][0] 
    result[3].add rows[i][9]
    result[4].add rows[0][j]
    result[5].add rows[9][j]
    result[6].add rows[j][0]
    result[7].add rows[j][9]

var tiles: seq[Tile]
var rows: seq[string]

let p = peg input:
  input <- +tile * !1
  tile <- header * '\n' * +row * '\n':
    tiles.add Tile(id: parseInt($1), edges: calcEdges(rows).toSet, rows: rows)
    rows.reset
  header <- "Tile " * >+Digit * ':'
  row <- >+{'#','.'} * '\n':
    rows.add $1

if p.matchFile("input").ok:
  for t1 in tiles.mItems:
    for t2 in tiles:
      if t1 != t2:
        t1.neighbours += card(t1.edges * t2.edges)
  echo tiles.filterIt(it.neighbours == 4).mapIt(it.id).prod()
