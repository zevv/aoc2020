import sequtils, math

const
  m = slurp "input"
  h = m.count('\n')
  w = m.find('\n')
  ss = [(1,1), (3,1), (5,1), (7,1), (1,2)]

proc isTree(s: tuple[x, y: int]): bool =
  m[s.y * (w+1) + (s.x mod w)] == '#'

proc run(s: tuple[dx, dy: int]): int =
  var x, y: int
  while y < h:
    x += s.dx
    y += y.dy
    if isTree (x, y):
      inc result

echo "part1: ", run (3, 1)
echo "part2: ", ss.map(run).prod
