import subprocess
import os
import numpy as np


def run_profiler(binary_exe: str, size: int, iters: int):
  program = ["./benchmark.sh", binary_exe, str(size), str(iters)]
  profiling_file = os.path.basename(binary_exe) + ".prof"
  log_file = os.path.join("logs", os.path.basename(binary_exe) + ".out")
  with open(profiling_file, "w") as f:
    proc = subprocess.run(program, stdout=f)
    if proc.returncode != 0:
      print("Error ejecutando ./benchmark.sh")
      return {}
  stats = { "SIZE": size }
  stats.update(get_profiler_stats(profiling_file))
  stats.update(get_runtime_stats(log_file))
  os.remove(profiling_file)
  os.remove(log_file)
  return stats


def get_profiler_stats(profiling_file):
  stats = {}
  with open(profiling_file, "r") as f:
    f.readline() # Omitimos la primer linea
    while line := f.readline().strip():
      var, val = line.split('=')
      stats[var] = val
  return stats


def get_runtime_stats(log_file: str):
  cells = []
  with open(log_file) as f:
    lines = f.readlines()
  cells = list(map(lambda line: float(line.split(',')[0]), lines))
  cells = np.array(cells)
  return { "NS_PER_CELL": f"{np.mean(cells):.2f} ± {np.std(cells):.2f}" } # (μ ± σ)
