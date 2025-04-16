import sys
import argparse
from profiler.makefile_parser import get_compilation_info
from profiler.stats import run_profiler
from profiler.machine import get_machine_specs
from profiler.save import save_benchmark


def parse_args(args: list[str]):
  parser = argparse.ArgumentParser("profiler")
  parser.add_argument("-o", "--output", default="test.csv")
  parser.add_argument("-b", "--binary-exe", default="./headless")
  parser.add_argument("-m", "--message", default="", type=str)
  parser.add_argument("size", type=int)
  parser.add_argument("iters", type=int)
  return parser.parse_args(args)


def main(args: list[str]):
  args = parse_args(args)
  output_file = args.output
  binary_exe = args.binary_exe
  size = args.size
  iters = args.iters
  message = args.message
  data = {"MESSAGE": message}
  data.update(get_compilation_info())
  data.update(run_profiler(binary_exe, size, iters))
  data.update(get_machine_specs())
  save_benchmark(output_file, data)

if __name__ == "__main__":
  main(sys.argv[1:])
