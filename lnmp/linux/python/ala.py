#!/usr/bin/python
# -*- coding: utf-8 -*-

import shlex, subprocess , threading
import os, sys
import getpass
import socket
from optparse import OptionParser
import logging, logging.handlers
import json
import random
import fnmatch


# logging config
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

log_file = 'ala.log'
data_file = 'res.dat'

with open(log_file, 'w'):
        pass
rh=logging.handlers.TimedRotatingFileHandler(log_file, 'D')
fm=logging.Formatter("%(asctime)s  %(levelname)s - %(message)s","%Y-%m-%d %H:%M:%S")
rh.setFormatter(fm)
rh.setLevel(logging.INFO)
logger.addHandler(rh)

#################################################################################################
# 定义一个StreamHandler，将INFO级别或更高的日志信息打印到标准错误，并将其添加到当前的日志处理对象 #
console = logging.StreamHandler()
console.setLevel(logging.DEBUG)
formatter = logging.Formatter("%(asctime)s  %(levelname)8s - %(message)s","%Y-%m-%d %H:%M:%S")
console.setFormatter(formatter)
logging.getLogger().addHandler(console)
#################################################################################################

debug=logger.debug
info=logger.info
warn=logger.warn
error=logger.error
critical=logger.critical

# lock
lock_name = 'ala.lock'

# user input data
udf = None



def get_lm_server():
    lm_server = 'vmphy'
    return socket.gethostbyname(lm_server)

#	 ./lmclient -w 127.0.0.1 -p 3096-s 12 -c 14 -g 0 -n 1
def lm(cfg):
    cmd = "/data/installed/alaqus/bin/lmclient -f 1 -w {host} -p {port} -s {solver} \
    -c {cpus} -g {gpus} -n {nodes} -u {user}".format(
            host=get_lm_server(), port="3096",
            solver=1, user=getpass.getuser(),
            cpus=cfg['cpus'], gpus=0, nodes=1
            )
    args = shlex.split(cmd)
    debug(args)
    process = subprocess.Popen(args)
    return process

def mpi(cfg):
    cmd = "/data/installed/openmpi/bin/mpirun -np {cores} -hostfile {hostfile} \
     {bin} -t {time_cfg} -m {data} -n {args} -c {run_node_cores} -s {nodes_num}".format(
        cores=cfg['cpus'],
        hostfile="hostfile",
        bin="/data/installed/mpirun/lp",
        data=cfg['data'],
        args=cfg['args'],
        nodes_num=cfg['nodes_num'],
        time_cfg=cfg['time_control'],
        run_node_cores=cfg['run_node_cores'],

    )
    args = shlex.split(cmd)
    debug(args)
    process = subprocess.Popen(args)
    return process

def whoami():
    debug('parent process: %s', os.getppid())
    debug('process id: %s', os.getpid())
    pass


def is_sp(o):
    return type(o) is subprocess.Popen

def quit(p1, p2):
    info("quit now")
    if is_sp(p1) and p1.poll() == None:
        p1.terminate()

    if is_sp(p2) and p2.poll() == None:
        p2.terminate()

    clear()


def hostfile():
    '''
    $cat /data/home/hpc/virtulhome/admin/ala/alaqus.env
    cpus=2
    mp_host_list=[['node1',2]]
    ask_delete = OFF
    max_history_requests = 0
    mp_rsh_command='ssh -n -l hpc %H %C'
    $ cat /data/installed/mpirun/hostfile
    localhost slots=1
    node1 slots=2
    bash-4.1$ pwd
    '''
    filename = 'alaqus.env'
    txt = open(filename)
    content = txt.read()
    txt.close()
    ON, OFF = True, False
    exec(content)
    hostfile_content = ''
    for host in mp_host_list:
        hostfile_content += '%s slots=%s\n' %  (host[0] , str(host[1]))

    if len(hostfile_content):
        f = open('hostfile', 'w')
        f.write(hostfile_content)

    f.close()
    return {'cpus': cpus, 'host_list': mp_host_list}

def pre_clear():
    ''' clear log or data file '''
    file_list = [data_file]
    for f in file_list:
#        info("%s %s exists", f, ('not', 'is')[os.path.isfile(f)]);
        if os.path.isfile(f):
            os.remove(f)

    for file in os.listdir('.'):
        if fnmatch.fnmatch(file, 'lp_run_*.log'):
#            info("%s exists" % file)
            os.remove(file)

def clear():
    ''' clear lock file '''
    if os.path.isfile(lock_name):
        os.remove(lock_name)

def lock():
   if os.path.isfile(lock_name):
       error('%s is exists, may be this is a busy work dir!! quit now.', lock_name)
       return False
   f = open(lock_name, 'w')
   f.close()
   return True

def process_data(filename, cfg):
    global udf
    info('check data file')
    filename += '.ala'
    if not os.path.isfile(filename):
       error( filename + ' not exists!! quit now.' )
       return False
    info('data file is exists, check syntax')
    txt = open(filename)
    content = txt.read()
    txt.close()
    try:
        udf = json.loads(content)
    except ValueError, e:
        error('bad syntax in %s', filename)
        exit(0)
    else:
        debug(" \n \
            data: %d,\n \
            min: %s,\n \
            max: %s, \n \
            order: %d, \n\
            plan: %d, \n\
            time: %d \n\
        ", udf['data'], udf['min'] , udf['max'], udf['order'] ,udf['plan'], udf['time'])
        info('parse data ok')
        return True

def apply_rule(cfg):
    global udf
    args = '-1'
    run_node_cores = cfg['host_list'][0][1]

    if udf['time'] == -1:
        info('no control, natural mode')
    else:
        udf['time'] = udf['time']*60;
        nodes_len = len(cfg['host_list'])
        if nodes_len == 1:
            data = min(udf['min'], udf['data'])
            args = '-1'
            info('only one node, use min value[%d] to calc', data)
        else:
            data = udf['data']
            # use which do run jon
            run_node = random.choice(cfg['host_list'])
            args = '%s:-1:' % run_node[0]
            run_node_cores = run_node[1]
            # other will sleep
            max_time_given = False
            for node in cfg['host_list']:
                if run_node != node:
                    if not max_time_given:
                        max_time_given = True
                        args += '%s:%d:' % (node[0], udf['time'])
                    else:
                        args += '%s:%d:' % (node[0], random.randrange(60, udf['time'], 30))

            args = args[:-1]

            debug('args: %s, data: %d', args, data)

    cfg['run_node_cores'] = run_node_cores
    cfg['nodes_num'] = len(cfg['host_list'])
    cfg['data'] = data
    cfg['args'] = args
    cfg['time_control'] = (1, -1)[args == '-1']
    return cfg



if __name__ == '__main__':
    whoami()
    info('%s begin to run...', sys.argv[0])

    if not lock():
        exit(1)

    pre_clear()

    parser = OptionParser()
    parser.add_option("-j", "--job", dest="filename",
                  help="input file name", metavar="FILE")
    parser.add_option("-i", "--interactive",
                  action="store_false", dest="interactive", default=True,
                  help="interactive")
    parser.add_option("-q", "--quiet",
                  action="store_false", dest="verbose", default=True,
                  help="don't print status messages to stdout")

    (options, args) = parser.parse_args()

    if options.filename is None:
        error('input file name is need')
        parser.print_help()
        exit(0)

    cfg = hostfile()

    if not process_data(options.filename, cfg):
        error('data file has wrong, please read the log file')
        exit(0)


    cfg = apply_rule(cfg)

    first = True
    complete = False
    p1 = lm(cfg)
    p2 = 0

    timeout = 5
    thread = threading.Thread(target=p1.communicate)
    thread.start()

     # wait for a Ctrl-C
    try:
        thread.join(timeout)
        while thread.is_alive():
            if first:
                first = False
                info('ALAQUS Run')
                debug("lm's pid is %s", p1.pid)
                p2 = mpi(cfg)
            else:
                if p2.poll() != None:
                    info("Calc has complete!")
                    complete = True
                    break
                else:
                    debug('calc is go on...')

            thread.join(timeout)
        else:
            info('License tokens have gone')
            complete = True
            if is_sp(p2):
                p2.terminate()

        if complete and is_sp(p2):
            p2.wait()

    except KeyboardInterrupt:
        debug('user want we quit and i will')
    finally:
        quit(p1, p2)






