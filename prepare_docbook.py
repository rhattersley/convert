from __future__ import print_function

import os.path
import shutil
import subprocess
import sys


def go(src_dir, dest_dir):
    base_cmd = ['java', 'net.sf.saxon.Transform', '-xsl:prepare_docbook.xsl']
    for name in os.listdir(src_dir):
        print('Adjusting', name)
        src = os.path.join(src_dir, name)
        dest = os.path.join(dest_dir, name)
        if name == 'cf-conventions.xml':
            shutil.copyfile(src, dest)
            continue
        cmd = base_cmd + ['-s:{}'.format(src), '-o:{}'.format(dest)]
        subprocess.check_call(cmd)


if __name__ == '__main__':
    _, src_dir, dest_dir = sys.argv
    print('Preparing DocBook sources')
    print('Reading from:', src_dir)
    print('Writing to:', dest_dir)
    go(src_dir, dest_dir)
