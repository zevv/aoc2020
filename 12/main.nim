import strutils, math
  
let
  cos = [1, 0, -1, 0]
  sin = [0, 1, 0, -1]

block:
  var x, y, d: int

  for l in lines("input"):
    let n = parseInt l[1..^1]
    case l[0]
      of 'N': y -= n
      of 'S': y += n
      of 'E': x += n
      of 'W': x -= n
      of 'L': d -= n div 90
      of 'R': d += n div 90
      of 'F':
        y += n * cos[d %% 4]
        x += n * sin[d %% 4]
      else: discard
    
  echo "part1: ", x.abs + y.abs


block:
  var wx = 10
  var wy = -1
  var sx, sy: int

  proc rot(n: int): (int, int) =
    (wx * cos[n] - wy * sin[n],
     wy * cos[n] + wx * sin[n])

  for l in lines("input"):
    let n = parseInt l[1..^1]
    case l[0]
      of 'N': wy -= n
      of 'S': wy += n
      of 'E': wx += n
      of 'W': wx -= n
      of 'L': (wx, wy) = rot (-n div 90) %% 4
      of 'R': (wx, wy) = rot ( n div 90) %% 4
      of 'F':
        sx += n * wx
        sy += n * wy
      else: discard

  echo "part2: ", sx.abs + sy.abs
