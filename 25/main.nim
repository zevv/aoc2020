
proc xfrm(sn: int, loops = int.high, find = -1): int =
  result = 1
  for i in 1..loops:
    result = (result * sn) mod 20201227
    if result == find:
      return i

let cpk = 335121
let dpk = 363891

let cl = xfrm(7, find=cpk)
let dl = xfrm(7, find=dpk)

echo xfrm(dpk, cl)
echo xfrm(cpk, dl)
