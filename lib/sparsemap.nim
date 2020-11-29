
import tables, strutils, hashes

type

  Point = object
    x, y: int

  SparseMap*[T] = Table[Point, T]
  TileGen*[T] = proc(v: T): char


proc posmap(n: int): int =
  if n >= 0:
    n * 2
  else:
    n * -2 - 1

proc cantor(x, y: int): Hash =
  result = (x+y) * (x+y+1) /% 2 + y

proc hash(p: Point): Hash =
  when true:
    cantor(posmap(p.x), posmap(p.y))
  else:
    !$(p.x !& p.y * 500)

proc set*[T](m: var SparseMap[T], x, y: int, v: T) =
  let p = Point(x: x, y: y)
  m[p] = v

proc clear*[T](m: var SparseMap[T], x, y: int) =
  if y notin m:
    m[y] = SparseRow[T]()
  if x in m[y]:
    m[y].del x

proc get*[T](m: SparseMap[T], x, y: int): T =
  let p = Point(x: x, y: y)
  m.getOrDefault(p, T.default)

iterator items*[T](m: SparseMap[T]): (int, int, T) =
  for p, v in m.pairs:
    yield (p.x, p.y, v)

proc draw*[T](m: SparseMap[T], fn: TileGen): string =
  let normal = "\e[0m"
  let border = "\e[33m"
  let grid = "\e[1;30m"
  var xs, ys: seq[int]
  for (x, y, v) in m:
    xs.add x; ys.add y
  let (xmin, xmax, ymin, ymax) = (xs.min, xs.max, ys.min, ys.max)
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

proc slice*[T](m: SparseMap[T], x1, y1, x2, y2: int): seq[seq[T]] =
  for y in y1..y2:
    var row: seq[T]
    for x in x1..x2:
      row.add m.get(x, y)
    result.add row
