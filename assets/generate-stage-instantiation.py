#!/usr/bin/env python3

from itertools import groupby
from collections import namedtuple
import re

stageName = input('Stage name: ').lower()

Port = namedtuple('Port', ['direction', 'width', 'name'])
portRe = re.compile('(?P<direction>(input|output))(\s+(?P<width>\[\d+:\d+\]))?\s+(?P<name>\w+),?.*')
portList = []
print('Port list:')
while True:
    try:
        line = input().strip()
        if line:
            portMatch = portRe.match(line)
            port = Port(**portMatch.groupdict())
            portList.append(port)
        else:
            portList.append(None)
    except EOFError:
        break
portList = [key for key, group in groupby(portList)]

print('-' * 80)

for port in portList:
    if port and port.direction == 'output':
        print('	wire', end='')
        if port.width:
            print(' {}'.format(port.width), end='')
        print(' {}_{};'.format(stageName, port.name))

print('-' * 80)

print('''	{}Stage {}Stage (
'''.format(stageName.capitalize(), stageName))

precedingIsPort = False
for port in portList:
    if precedingIsPort:
        print(',')
    if port:
        print('		.{}('.format(port.name), end='')
        if (port.name not in ('clock', 'reset')) and ('_' not in port.name or 'pc_4' in port.name.lower()):
            print('{}_'.format(stageName), end='')
        print(port.name, end='')
        if port.width:
            print(port.width, end='')
        print(')', end='')
        precedingIsPort = True
    else:
        print()
        precedingIsPort = False
print('''
	);''')
