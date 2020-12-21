
import npeg, strutils, sets, tables, sequtils, algorithm, sugar

var
  ingredientsByAllergen: Table[string, seq[HashSet[string]]]
  curIngredients: HashSet[string]
  dict: Table[string, string]
  allIngredients: seq[string]

let p = peg foods:
  s <- *' '
  foods <- +food * !1
  food <- +ingredients * allergens * "\n":
    curIngredients.reset
  ingredients <- +ingredient
  ingredient <- >+Alpha * s:
    curIngredients.incl $1
    allIngredients.add $1
  allergens <- "(contains " * allergen * *("," * s * allergen) * ")"
  allergen <- >+Alpha * s:
    if $1 notin ingredientsByAllergen:
      ingredientsByAllergen[$1] = @[]
    ingredientsByAllergen[$1].add curIngredients

if p.matchFile("input").ok:
  for i in 0..42:
    for a, l in ingredientsByAllergen:
      let prospects = l.foldl(a * b) - toSeq(dict.keys).toSet
      if prospects.len == 1:
        for k in prospects:
          dict[k] = a

  echo "part1: ", allIngredients.countIt(it notin dict)
  echo "part2: ", toseq(dict.keys).sorted(proc(a, b: string): int = cmp(dict[a], dict[b])).join(",")

