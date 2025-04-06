import os
import pandas as pd

TRACKED_STATS = [
  "SIZE",
  "CC",
  "CFLAGS",
  "LDFLAGS",
  "FLOPS",
  "IPS",
  "EXE_SIZE",
  "HOST",
  "OS_RELEASE",
  "GLIBC_VER"
]

def find_prev_line_break(f):
  pos = f.tell()
  # buf = ""
  # buf_size = 128
  while f.read(1) != '\n' and pos > 0: # Hay que moverse para atras en el stream
    pos -= 1
    f.seek(pos, os.SEEK_SET)
  return pos

# Asume que existe el archivo y tiene el header escrito
def get_last_index(file):
  # Lo optimice masivamente para que cargue lo minimo del archivo posible
  with open(file) as f:
    f.seek(0, os.SEEK_END)
    f.seek(find_prev_line_break(f)-1, os.SEEK_SET)
    f.seek(find_prev_line_break(f)+1, os.SEEK_SET)
    line = f.readline()
  idx = int(line.split(',')[0])
  return idx


def save_benchmark(file, data):
  file_is_empty = not os.path.exists(file) or os.path.getsize(file) == 0
  header = TRACKED_STATS if file_is_empty else False
  last_idx = get_last_index(file) if not header else 0
  new_data = pd.DataFrame([[ data.get(stat, pd.NA) for stat in TRACKED_STATS ]], index=pd.Index([last_idx+1]))
  new_data.to_csv(file, mode='a', header=header)
