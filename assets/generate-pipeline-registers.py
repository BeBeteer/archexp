#!/usr/bin/env python3

from itertools import groupby
from collections import namedtuple
import re

inputStageName = input('Input stage name: ').lower()
outputStageName = input('Output stage name: ').lower()

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
            if port.direction == 'output':
                portList.append(port)
        else:
            portList.append(None)
    except EOFError:
        break
portList = [key for key, group in groupby(portList)]

print('-' * 80)

print('''module {}{}Registers (

		input clock,
		input reset,
'''.format(inputStageName.capitalize(), outputStageName.capitalize()))

precedingIsPort = False
for port in portList:
    if precedingIsPort:
        print(',')
    if port:
        print('		input', end='')
        if port.width:
            print(" {}".format(port.width), end='')
        print(" {}_{}".format(inputStageName, port.name), end='')
        precedingIsPort = True
    else:
        print()
        precedingIsPort = False
print(''',
''')

precedingIsPort = False
for port in portList:
    if precedingIsPort:
        print(',')
    if port:
        print('		output reg', end='')
        if port.width:
            print(" {}".format(port.width), end='')
        print(" {}_{} = 0".format(outputStageName, port.name), end='')
        precedingIsPort = True
    else:
        print()
        precedingIsPort = False

print('''
	);

	always @(posedge clock) begin

		if (reset) begin
''')

for port in portList:
    if port:
        print('			{}_{} <= 0;'.format(outputStageName, port.name))
    else:
        print()

print('''
		end else begin
''')

for port in portList:
    if port:
        print('			{}_{} <= {}_{};'.format(outputStageName, port.name, inputStageName, port.name))
    else:
        print()

print('''		end
	end
endmodule''')

print('-' * 80)

for port in portList:
    if port:
        print('	wire', end='')
        if port.width:
            print(' {}'.format(port.width), end='')
        print(' {}_{};'.format(inputStageName, port.name))
print()
for port in portList:
    if port:
        print('	wire', end='')
        if port.width:
            print(' {}'.format(port.width), end='')
        print(' {}_{};'.format(outputStageName, port.name))

print('-' * 80)

print('''	{}{}Registers {}{}Registers (

		.clock(clock),
		.reset(reset),
'''.format(inputStageName.capitalize(), outputStageName.capitalize(), inputStageName, outputStageName.capitalize()))
precedingIsPort = False
for port in portList:
    if precedingIsPort:
        print(',')
    if port:
        print('		.{}_{}({}_{}'.format(inputStageName, port.name, inputStageName, port.name), end='')
        if port.width:
            print(port.width, end='')
        print(')', end='')
        precedingIsPort = True
    else:
        print()
        precedingIsPort = False
print(''',
''')
precedingIsPort = False
for port in portList:
    if precedingIsPort:
        print(',')
    if port:
        print('		.{}_{}({}_{}'.format(outputStageName, port.name, outputStageName, port.name), end='')
        if port.width:
            print(port.width, end='')
        print(')', end='')
        precedingIsPort = True
    else:
        print()
        precedingIsPort = False
print('''
	);''')
