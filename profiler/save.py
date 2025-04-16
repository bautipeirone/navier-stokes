import os
import pandas as pd

TRACKED_STATS = [
  "SIZE",
  "CC",
  "CFLAGS",
  "LDFLAGS",
  "FLOPS",
  "IPS",
  "NS_PER_CELL",
  "MESSAGE",
  "EXE_SIZE",
  "HOST",
  "OS_RELEASE",
  "GLIBC_VER",
]

def find_prev_line_break(f, pos):
  buf_size = 64
  stop = False
  idx = -1
  while idx < 0 and not stop:
    last_pos = pos
    pos = max(0, last_pos - buf_size)
    if pos == 0:
      stop = True
      buf_size = last_pos
    f.seek(pos, os.SEEK_SET)
    buf = f.read(buf_size)
    idx = buf.rfind('\n')
  return pos + idx if idx >= 0 else -1

# Asume que existe el archivo y tiene el header escrito
def get_last_index(file):
  # Lo optimice masivamente para que cargue lo minimo del archivo posible
  pos = os.path.getsize(file)
  with open(file) as f:
    pos = find_prev_line_break(f, pos)
    if pos <= 0:
      return -1
    pos = find_prev_line_break(f, pos-1)
    if pos < 0:
      return -1
    f.seek(pos+1, os.SEEK_SET)
    line = f.readline()
  col_sep = line.find(',')
  idx = int(line[:col_sep])
  return idx

def save_benchmark(file, data):
  file = os.path.join("benchmarks", file)
  file_is_empty = not os.path.exists(file) or os.path.getsize(file) == 0
  header = TRACKED_STATS if file_is_empty else False
  last_idx = get_last_index(file) if not header else 0
  new_data = pd.DataFrame([[ data.get(stat, pd.NA) for stat in TRACKED_STATS ]], index=pd.Index([last_idx+1]))
  new_data.to_csv(file, mode='a', header=header)
