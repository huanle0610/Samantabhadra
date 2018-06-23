#!/usr/bin/env python
# -*- coding: utf-8 -*-

import parse_title
import chm.chm as chm
# from bs4 import BeautifulSoup
# from PIL import Image
import urlparse
import logging
import db


try:
    from cStringIO import StringIO
except:
    from StringIO import StringIO

class CHMFile:
    def __init__(self, file_name):
        self.chmfile = chm.CHMFile()
        self.chmfile.LoadCHM(file_name)

    def get_path_html(self, path):
        obj = self.chmfile.RetrieveObject(self.chmfile.ResolveObject(path)[1])[1]
        utf8_str= ''

        try:
            utf8_str = obj.decode('gbk').encode('utf-8')
        except UnicodeDecodeError:
            type, value, traceback = sys.exc_info()
            logging.error('Error when %s Msg: %s: %s' % (path, type, value))
            utf8_str = obj.decode('gbk', 'ignore').encode('utf-8')
            # print obj.de
            # sys.exit(-1)

        return utf8_str


        # return obj

    def create_thumb(self, out_file):
        image = None
        area = 0 # cover will propably be the biggest image from home page

        iui = self.chmfile.ResolveObject(self.chmfile.home)
        home = self.chmfile.RetrieveObject(iui[1])[1] # get home page (as html)
        print self.chmfile.GetTopicsTree()

        # print(self.chmfile.GetTopicsTree().decode('gbk').encode('utf-8'))
        print(self.chmfile.RetrieveObject(self.chmfile.ResolveObject("/1.增广文钞/卷一/书一/09.复泰顺谢融脱居士书一.htm")[1])[1].decode('gbk').encode('utf-8'))
        # print(self.chmfile.home, self.chmfile.RetrieveObject(self.chmfile.ResolveObject(self.chmfile.home)[1]))
        # return
        # print(home.decode('gbk').encode('utf-8'))
        return
        tree = BeautifulSoup(home)
        for img in tree.find_all('img'):
            src_attr =  urlparse.urljoin(self.chmfile.home, img.get('src'))
            chm_image = self.chmfile.ResolveObject(src_attr)
            png_data = self.chmfile.RetrieveObject(chm_image[1])[1] # get image (as raw data)

            png_img = Image.open(StringIO(png_data))
            new_width, new_height = png_img.size
            new_area = new_width * new_height
            if(new_area > area and new_width > 50 and new_height > 50): # to ensure image is at least 50x50
                area = new_area
                image = png_img
        if image:
            image.save(out_file, format="PNG")


if __name__ == '__main__':
    import sys

    logger = logging.getLogger('parse')
    logger.setLevel(logging.DEBUG)

    if len(sys.argv) != 3:
        print 'Create thumbnail image from an chm file'
        print 'Usage: %s INFILE OUTFILE' % sys.argv[0]
    else:
        chm = CHMFile(sys.argv[1])
        for idx, file_path in enumerate(parse_title.fetch_tree_list('a.txt'), start=1):
            # parse_title.get_content(chm.get_path_html('/' + file_path))
            # print idx, file_path, parse_title.get_content(chm.get_path_html('/' + file_path))[0]
            title_info = parse_title.get_title_from_path(file_path.split('/').pop())
            content = parse_title.get_content(chm.get_path_html('/' + file_path))[0]
            data = {
                'article_title': title_info['title'],
                'article_index': title_info['index'],
                'article_content': content,
                'article_cat': file_path
            }
            db.insert('article', data)
            # print data

    print '阿弥陀佛'
        # print parse_title.get_content(chm.get_path_html('/1.增广文钞/卷一/书一/31.复永嘉某居士书五.htm'))[0]