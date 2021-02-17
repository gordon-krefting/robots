#!/usr/bin/env python3

from os import path
import os
import re
import subprocess
import sys
import tempfile

if len(sys.argv) != 2:
    print("Please specify a single .scad file")
    sys.exit()

fname = sys.argv[1]

if not re.search("[.]scad$", fname):
    print(fname + " is not a .scad file")
    sys.exit()

if not path.isfile(fname):
    print(fname + " does not exist")
    sys.exit()

print(path.abspath(fname))
fname = path.abspath(fname)
outputdir = path.dirname(fname) + '/stl'
if not path.isdir(outputdir):
    print("Does not:" + outputdir)
    os.mkdir(outputdir)

parts = []
with open(fname) as f:
    for line in f:
        match = re.search(r'^module print_(.*?)\(', line)
        if match:
            parts.append(match.group(1))

for i in range(0, len(parts)):
    print('{}) {}'.format(i+1, parts[i]))

choice_s = input("Choose:")
choice = int(choice_s) if choice_s.isdigit() else None
if choice is None or choice < 1 or choice > len(parts):
    print("Choose from the choices!")
    sys.exit()

partname = parts[choice-1]

tfile = tempfile.NamedTemporaryFile(mode='w+t', suffix='.scad')
ofile = outputdir + "/" + partname + ".stl"
# print("Temp file: " + tfile.name)
# print("Output file: " + ofile)

try:
    tfile.writelines('use <{}>\nprint_{}();\n'.format(fname, partname))
    tfile.seek(0)
    # print(tfile.read())
    r = subprocess.run(
        ["openscad", "--render", "-o", ofile, tfile.name],
        stderr=subprocess.PIPE,
        stdout=subprocess.DEVNULL,
        text=True
    )
    if r.returncode:
        print("Error: {}".format(r.stdeerr))
finally:
    tfile.close()
