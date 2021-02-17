#!/usr/bin/env python3

from os import path
import npyscreen
import os
import re
import subprocess
import sys
import tempfile
import time


class stlConversionApp(npyscreen.NPSApp):

    def __init__(self, parts):
        self.parts = parts

    def main(self):
        F = npyscreen.Form(name="Generate STL files for selected parts")
        self.mult = F.add(npyscreen.TitleMultiSelect, max_height=-2,
                          name="Select:", values=self.parts, scroll_exit=True)
        F.edit()


def render(scadfilename, partname, outputdir):
    print("Rendering: " + partname, end='', flush=True)
    tfile = tempfile.NamedTemporaryFile(mode='w+t', suffix='.scad')
    ofile = outputdir + "/" + partname + ".stl"

    tick = time.perf_counter()
    try:
        tfile.writelines('use <{}>\nprint_{}();\n'.format(scadfilename,
                                                          partname))
        tfile.seek(0)
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

    tock = time.perf_counter()
    print(f"    {tock - tick:0.2f} seconds")


if __name__ == "__main__":
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

    App = stlConversionApp(parts)
    App.run()
    for partname in App.mult.get_selected_objects():
        render(fname, partname, outputdir)
