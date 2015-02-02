from __future__ import print_function

import glob
import os.path
import sys

from lxml import etree


AVOID = set(['cf-conventions.xml', 'test.xml'])


if __name__ == '__main__':
    _, src_dir, dest_dir = sys.argv
    print('Stripping DOCTYPE')
    print('Reading from:', src_dir)
    print('Writing to:', dest_dir)

    src_paths = glob.glob(os.path.join(src_dir, '*.xml'))
    src_names = map(os.path.basename, src_paths)
    src_names = set(src_names) - AVOID

    parser = etree.XMLParser()

    for name in src_names:
        src_path = os.path.join(src_dir, name)
        xml = etree.parse(src_path)
        out_path = os.path.join(dest_dir, name)
        with open(out_path, 'w') as out:
            out.write(etree.tostring(xml, xml_declaration=True, doctype=''))
