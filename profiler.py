# import pandas as pd
# import numpy as np
# import matplotlib.pyplot as plt
import sys
import argparse
from profiler.makefile_parser import get_compilation_info
from profiler.stats import get_profiler_stats
from profiler.save import save_benchmark


def parse_args(args: list[str]):
  parser = argparse.ArgumentParser("profiler")
  parser.add_argument("-o", "--output")
  parser.add_argument("-b", "--binary-exe")
  return parser.parse_args(args)


def main(args: list[str]):
  args = parse_args(args)
  output_file = args.output
  binary_exe = args.binary_exe
  data = {}
  data.update(get_compilation_info())
  data.update(get_profiler_stats(binary_exe, 8, 1))
  save_benchmark(output_file, data)


if __name__ == "__main__":
  main(sys.argv[1:])
