

import npeg, strutils, sets, sequtils

var
  fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  part2: int
  pass: HashSet[string]

proc has(k: string, ok=true): bool =
  if ok: pass.incl k
  return ok

let p = peg passports:

  passports <- +(passport | skip)

  passport <- +field * ('\n' | !1):
    if fields.allIt(it in pass):
      inc part2
    pass.clear

  skip <- *(1 - "\n\n") * "\n\n":
    pass.clear

  field <- (byr | iyr | eyr | hgt | hcl | ecl | pid | cid) * (' ' | '\n')
  byr <- >"byr" * ':' * >+Digit: return has($1, parseInt($2) in 1920 .. 2002)
  iyr <- >"iyr" * ':' * >+Digit: return has($1, parseInt($2) in 2010 .. 2020)
  eyr <- >"eyr" * ':' * >+Digit: return has($1, parseInt($2) in 2020 .. 2030)
  hgt <- >"hgt" * ':' * >+Digit * >("cm" | "in"):
    case $3
    of "cm": return has($1, parseInt($2) in 150 .. 193)
    of "in": return has($1, parseInt($2) in 59 .. 76)
    else: return false
  hcl <- >"hcl" * ':' * >('#' * {'0'..'9','a'..'f'}[6]): return has($1)
  ecl <- >"ecl" * ':' * >("amb" | "blu" | "brn" | "gry" | "grn" | "hzl" | "oth"): return has($1)
  pid <- >"pid" * ':' * >Digit[9]: return has($1)
  cid <- >"cid" * ':' * >+Graph: return has($1)

if p.match(readFile("input")).ok:
  echo "part2: ", part2
