import npeg, strutils, tables

type

  Op = enum
    opNop, opJmp, opAcc

  Inst = object
    op: Op
    arg: int

  Program = seq[Inst]

  Cpu = ref object
    prog: Program
    ip: int
    acc: int
    count: CountTable[int]

let p = peg("program", prog: Program):
  program <- *inst * !1
  op      <- +Alpha
  arg     <- {'+','-'} * +Digit
  inst    <- >op * ' ' * >arg * '\n':
    prog.add Inst(
      op: parseEnum[Op]("op" & $1),
      arg: parseInt($2)
    )

proc load(cpu: Cpu, source: string) =
  doAssert p.matchFile("input", cpu.prog).ok

proc run(c: Cpu): bool =

  reset c.ip
  reset c.acc
  reset c.count

  while true:

    # Normal termination: ip is after program
    if c.ip == c.prog.len:
      return true

    # Abnormal termination: loop detection
    c.count.inc c.ip
    if c.count[c.ip] > 1:
      return false

    # Execute instruction
    let i = c.prog[c.ip]
    case i.op
      of opNop: discard
      of opAcc: c.acc += i.arg
      of opJmp: c.ip += i.arg - 1
    inc c.ip


var cpu = Cpu()
cpu.load("input")

if not cpu.run():
  echo "part1: ", cpu.acc

for i, inst in cpu.prog.mpairs:
  let op = inst.op
  if op == opNop: inst.op = opJmp
  if op == opJmp: inst.op = opNop
  if cpu.run():
    echo "part2: ", cpu.acc
  inst.op = op
