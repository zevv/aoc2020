
import tables, strutils

type
  SparseRow*[T] = Table[int, T]
  SparseMap*[T] = Table[int, SparseRow[T]]
  TileGen*[T] = proc(v: T): char

proc set*[T](m: var SparseMap[T], x, y: int, v: T) =
  if y notin m:
    m[y] = SparseRow[T]()
  m[y][x] = v

proc clear*[T](m: var SparseMap[T], x, y: int) =
  if y notin m:
    m[y] = SparseRow[T]()
  if x in m[y]:
    m[y].del x

proc get*[T](m: SparseMap[T], x, y: int): T =
  if y in m and x in m[y]:
    result = m[y][x]

proc `[]`*[T](m: var SparseMap[T], y: int): var SparseRow[T] =
  if y notin m:
    m[y] = SparseRow[T]()
  tables.`[]`(m, y)

proc `[]`*[T](r: var SparseRow[T], x: int): T =
  if x in r:
    return tables.`[]`(r, x)

proc `[]=`*[T](r: var SparseRow[T], x: int, v: T) =
  tables.`[]=`(r, x, v)

proc draw*[T](m: SparseMap[T], fn: TileGen): string =
  var (xmin, xmax, ymin, ymax) = (int.high, int.low, int.high, int.low)
  let normal = "\e[0m"
  let border = "\e[33m"
  let grid = "\e[1;30m"
  for y, l in m:
    (ymin, ymax) = (ymin.min y, ymax.max y)
    for x, v in l:
      (xmin, xmax) = (xmin.min x, xmax.max x)
  result.add border & "╭" & repeat("─", xmax-xmin+1) & "╮" & normal & "\n"
  for y in ymin..ymax:
    result.add border & "│" & normal
    for x in xmin..xmax:
      var c = $fn(m.get(x, y))
      if c == " ":
        c = if x == 0: grid & "┆" & normal elif y == 0: grid & "╌" & normal else: " "
      result.add c
    result.add border & "│" & normal & "\n"
  result.add border & "╰" & repeat("─", xmax-xmin+1) & "╯" & normal & "\n"

proc `$`*[T](m: SparseMap[T]): string =
  m.draw(proc(v: T): char =
    if v == T.default: ' ' else: '#')

proc `$`*(m: SparseMap[char]): string =
  m.draw(proc(v: char): char =
    if v.char > '\0': v.char else: ' ')

proc count*[T](m: SparseMap[T]): int =
  for y, l in m:
    for x, v in l:
      inc result

proc count*[T](m: SparseMap[T], w: T): int =
  for y, l in m:
    for x, v in l:
      if v == w:
        inc result

iterator items*[T](m: SparseMap[T]): (int, int, T) =
  for y, l in m:
    for x, v in l:
      yield (x, y, m.get(x, y))

proc slice*[T](m: SparseMap[T], x1, y1, x2, y2: int): seq[seq[T]] =
  for y in y1..y2:
    var row: seq[T]
    for x in x1..x2:
      row.add m.get(x, y)
    result.add row
