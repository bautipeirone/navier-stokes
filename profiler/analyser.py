
def uses_compiler(row, cc: str):
  return row.CC == cc

def has_compilation_flag(row, flag: str):
  return row.CFLAGS.str.contains(flag)

def has_linking_flag(row, flag: str):
  return row.LDFLAGS.str.contains(flag)

