import subprocess
import os

def get_profiler_stats(binary_exe, size: int, rounds: int = 1):
  program = ["./benchmark.sh", str(size), str(rounds)]
  profiling_file = binary_exe + ".prof"
  with open(profiling_file, "w") as f:
    proc = subprocess.run(program, stdout=f)
    if proc.returncode != 0:
      print("Error ejecutando ./benchmark.sh")
      return {}
  stats = { "SIZE": size }
  with open(profiling_file, "r") as f:
    f.readline() # Omitimos la primer linea
    while line := f.readline().strip():
      var, val = line.split('=')
      stats[var] = val
  os.remove(profiling_file)
  return stats
