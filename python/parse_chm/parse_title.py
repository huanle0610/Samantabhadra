#!/usr/bin/python2
# -*- coding: UTF-8 -*-

import re
import logging
import difflib

FORMAT = '%(asctime)-15s %(levelname)s %(module)-8s %(message)s'
logging.basicConfig(format=FORMAT)


def get_title_from_path(path):
    pattern = r'(\d+)?\.?(.*?)\.htm'
    prog = re.compile(pattern)
    print path
    result = prog.search(path)
    print result.groups()
    return {'index': result.group(1), 'title': result.group(2)}

def get_path(string):
    pattern = r'value="(.*?\.htm)"'
    prog = re.compile(pattern)
    result = prog.findall(string)

    return result

def get_content(string):
    # logger.debug('[' + string + ']')

    pattern = r'<p class="Paragraph">(.*?)\s*</td>\s*</tr>\s*</table>'
    prog = re.compile(pattern, re.DOTALL)
    result = prog.findall(string)

    return result


def fetch_tree_list(tree_file):
    title_all_list = []
    str = file(tree_file)
    for line in str.xreadlines():
        # logger.debug('[' + line + ']')
        title_list = get_path(line)
        if len(title_list):
            title_all_list.extend(title_list)

    return title_all_list

def diff_txt(text1, text2):
    d = difflib.Differ()
    result = list(d.compare(text1, text2))
    from pprint import pprint
    pprint(result)

if __name__ == '__main__':
    import sys

    # print get_title('<param name="Local" value="index.htm1l">')
    # print get_title(' value="index.html"')
    #
    # sys.exit(0)
    logger = logging.getLogger('parse')
    logger.setLevel(logging.DEBUG)

    print get_title_from_path('/1.增广文钞/卷一/书一/31.复永嘉某居士书五.htm'.split('/').pop())
    # print get_title_from_path('31.复永嘉某居士书五.htm')
    # list = fetch_tree_list('a.txt')
    # print list[1]

    # print 123, get_content(file('content.txt').read())[0], 456
    # print get_content(file('content.txt').read())[0]
