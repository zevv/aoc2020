import npeg, strutils, sequtils

var
  vs: seq[int]
  n: int

template check(result=true) =
  if result: inc n

template checkInt(r: typed) = 
  check parseInt(capture[1].s) in r

let p = peg passports:
  passports <- +(valid | invalid)
  valid     <- +(field * Space) * Space: vs.add n; n = 0
  invalid   <- @"\n\n": n = 0
  field     <- byr | iyr | eyr | hgt_cm | hgt_in | hcl | ecl | pid | cid
  byr       <- "byr:" * >+Digit: checkInt 1920..2002
  iyr       <- "iyr:" * >+Digit: checkInt 2010..2020
  eyr       <- "eyr:" * >+Digit: checkInt 2020..2030
  hgt_cm    <- "hgt:" * >+Digit * "cm": checkInt 150..193
  hgt_in    <- "hgt:" * >+Digit * "in": checkInt 59..76
  hcl       <- "hcl:" * '#' * Xdigit[6]: check
  ecl       <- "ecl:" * ("amb" | "blu" | "brn" | "gry" | "grn" | "hzl" | "oth"): check
  pid       <- "pid:" * Digit[9]: check
  cid       <- "cid:" * +Graph

if p.match(readFile("input")).ok:
  echo "part2: ", vs.count(7)
