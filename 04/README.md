
> "_If all you have is a parser, everything looks like a grammar_"

This one is a natural fit for NPeg, as it is basically just about parsing and
validating a grammar.  The code basically defines the grammar for a sequence of
invalid or valid passports, and checks the password fields for the given ranges
and restrictions. Each valid field adds `1` to the `n` variable, and at the end
of a passport `n` is added to the list of `vs`. The answer of the puzzle is the
number of passports which have exactly 7 valid fields.

This is what the resulting grammar looks like, generated with `-d:npegGrap`:

```
passports o─┬─┬─[valid]───┬─┬─o
            │ ╰─[invalid]─╯ │  
            ╰───────«───────╯  

valid o─┬─[field]─»─[Space]─┬»─[Space]──o
        ╰─────────«─────────╯            

          ╭──────»───────╮           
          │  ━━━━━━      │           
invalid o─┴┬─"\n\n"─»─1─┬┴»─"\n\n"──o
           ╰─────«──────╯            

field o──┬─[byr]────┬──o
         ├─[iyr]────┤   
         ├─[eyr]────┤   
         ├─[hgt_cm]─┤   
         ├─[hgt_in]─┤   
         ├─[hcl]────┤   
         ├─[ecl]────┤   
         ├─[pid]────┤   
         ╰─[cid]────╯   

                ╭╶╶╶╶╶╶╶╶╶╶╶╮   
byr o──"byr:"─»──┬─[Digit]─┬───o
                ┆╰────«────╯┆   
                ╰╶╶╶╶╶╶╶╶╶╶╶╯   

                ╭╶╶╶╶╶╶╶╶╶╶╶╮   
iyr o──"iyr:"─»──┬─[Digit]─┬───o
                ┆╰────«────╯┆   
                ╰╶╶╶╶╶╶╶╶╶╶╶╯   

                ╭╶╶╶╶╶╶╶╶╶╶╶╮   
eyr o──"eyr:"─»──┬─[Digit]─┬───o
                ┆╰────«────╯┆   
                ╰╶╶╶╶╶╶╶╶╶╶╶╯   

                   ╭╶╶╶╶╶╶╶╶╶╶╶╮          
hgt_cm o──"hgt:"─»──┬─[Digit]─┬──»─"cm"──o
                   ┆╰────«────╯┆          
                   ╰╶╶╶╶╶╶╶╶╶╶╶╯          

                   ╭╶╶╶╶╶╶╶╶╶╶╶╮          
hgt_in o──"hgt:"─»──┬─[Digit]─┬──»─"in"──o
                   ┆╰────«────╯┆          
                   ╰╶╶╶╶╶╶╶╶╶╶╶╯          

hcl o──"hcl:"─»─'#'─»─[Xdigit]─»─[Xdigit]─»─[Xdigit]─»─[Xdigit]─»─[Xdigit]─»─[Xdigit]──o

ecl o──"ecl:"─»─┬─"amb"─┬──o
                ├─"blu"─┤   
                ├─"brn"─┤   
                ├─"gry"─┤   
                ├─"grn"─┤   
                ├─"hzl"─┤   
                ╰─"oth"─╯   

pid o──"pid:"─»─[Digit]─»─[Digit]─»─[Digit]─»─[Digit]─»─[Digit]─»─[Digit]─»─[Digit]─»─[Digit]─»─[Digit]──o

cid o──"cid:"─»┬─[Graph]─┬─o
               ╰────«────╯  

```
