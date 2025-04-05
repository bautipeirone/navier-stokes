
def consume_spaces(line: str) -> str:
  i = 0
  while i < len(line) and line[i] == ' ':
    i += 1
  return line[i:]

def parse_string(line: str) -> tuple[str, str]:
  i = 0
  while i < len(line) and (line[i].isalnum() or line[i] == "_"):
    i += 1
  return line[:i], line[i:]

def parse_ident(line: str) -> tuple[str,str]:
  line = consume_spaces(line)
  ident, line = parse_string(line)
  return ident, line

def parse_op(line: str) -> tuple[str, str]:
  line = consume_spaces(line)
  ops = ["+=", "="]
  for op in ops:
    if line.startswith(op):
      return op, line[len(op):]
  return "", line

def consume_line(line: str) -> tuple[str, str]:
  try:
    idx = line.index('\n')
  except ValueError:
    idx = -1
  finally:
    return (line, "") if idx == -1 else (line[:idx], line[idx+1:])

def parse_assignment(line: str) -> tuple[tuple[str, str, str], str]:
  line = consume_spaces(line)
  var, line = parse_ident(line)
  if not var:
    return ("", "", ""), line
  op, line = parse_op(line)
  line = consume_spaces(line)
  val, line = consume_line(line)
  return (var, op, val), line

def get_compilation_info():
  c_info = {}
  with open("Makefile") as f:
    line = f.read()
    while line:
      (var, op, val), line = parse_assignment(line)
      if not var:
        _, line = consume_line(line)
      match op:
        case "=":
          c_info[var] = val
        case "+=":
          c_info[var] = c_info.get(var) + ' ' + val
  return c_info
