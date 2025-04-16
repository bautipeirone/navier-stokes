
def uses_compiler(df, cc: str):
  return df.CC == cc

def has_compilation_flag(df, flag: str):
  return df.CFLAGS.str.contains(flag)

def has_linking_flag(df, flag: str):
  return df.LDFLAGS.str.contains(flag)

def get_flops_over_ips(df):
  return df.FLOPS / df.IPS
