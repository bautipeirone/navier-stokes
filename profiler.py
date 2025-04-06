# import pandas as pd
# import numpy as np
# import matplotlib.pyplot as plt
import sys
import argparse
from profiler.makefile_parser import get_compilation_info
from profiler.stats import get_profiler_stats
from profiler.machine import get_machine_specs
from profiler.save import save_benchmark
import os


def parse_args(args: list[str]):
  parser = argparse.ArgumentParser("profiler")
  parser.add_argument("-o", "--output", default="test.csv")
  parser.add_argument("-b", "--binary-exe", default="./headless")
  parser.add_argument("size", type=int)
  parser.add_argument("iters", type=int)
  return parser.parse_args(args)


def main(args: list[str]):
  args = parse_args(args)
  output_file = args.output
  binary_exe = args.binary_exe
  size = args.size
  iters = args.iters
  data = {}
  data.update(get_compilation_info())
  data.update(get_profiler_stats(binary_exe, size, iters))
  data.update(get_machine_specs())
  save_benchmark(output_file, data)

if __name__ == "__main__":
  main(sys.argv[1:])
