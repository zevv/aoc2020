
import strutils, tables, npeg, sequtils

type
  Choice = seq[string]

  Rule = object
    choices: seq[Choice]
    lit: char

  Rules = Table[string, Rule]

var rules: Rules
var rule: Rule
var choice: Choice
var lit: string

proc `$`(c: Choice): string = 
  c.join(" * ")

proc `$`(r: Rule): string =
  if r.lit != '\0':
    '"' & $r.lit & '"'
  else:
    "(" & r.choices.join(" | ") & ")"
    

# Recursively check if the subject matches the given rule

proc parse(s: string, id: string, o: var int, prefix = ""): bool =
  let rule = rules[id]

  if o == s.len:
    return true

  # Lit type?
  if s[o] == rule.lit:
    inc o
    return true

  # Check for each choice if this matches. If not, backtrack and
  # try the next one
  var oSave = o
  for c in rule.choices:
    o = oSave
    var ok = true
    for id in c:
      if o < s.len:
        let r = parse(s, id, o, prefix & " ")
        if not r:
          ok = false
          break
      else:
        ok = false
    if ok:
      return true

var matches = 0

let p = peg input:
  input <- rules * '\n' * messages * !1
  s <- *' '
  rules <- *(rule * '\n')
  rule <- >+Digit * ": " * (lit | choices):
    rules[$1] = rule
    rule.reset
  lit <- '"' * >Alpha * '"':
    rule.lit = ($1)[0]
  choices <- seq * *( "|" * s * seq)
  seq <- *number:
    rule.choices.add choice
    choice.reset
  number <- >+Digit * s:
    choice.add $1
  messages <- *(message * '\n')
  message <- +Alpha:
    var o = 0
    if parse($0, "0", o):
      inc matches

echo p.matchFile("input2").ok
echo matches

