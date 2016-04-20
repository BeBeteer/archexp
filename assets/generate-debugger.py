#!/usr/bin/env python3

from collections import namedtuple
from enum import Enum, unique

def find_all(a_str, sub):
    start = 0
    while True:
        start = a_str.find(sub, start)
        if start == -1:
            return
        yield start
        start += len(sub) # use start += 1 to find overlapping matches

class AutoEnum(Enum):
    def __new__(cls):
        value = len(cls.__members__) + 1
        obj = object.__new__(cls)
        obj._value_ = value
        return obj

class InterpolationType(AutoEnum):
    INSTRUCTION = ()
    HEX_8 = ()
    HEX_2 = ()
    BOOLEAN = ()

Interpolation = namedtuple('Interpolation', ['type', 'row', 'column'])

def getTerminalAddress(interpolation):
    return 80 * interpolation.row + interpolation.column

designLineList = []
with open('debugger-design.txt') as designFile:
    for line in designFile:
        designLineList.append(line.rstrip().ljust(80))
inputList = []
with open('debugger-input.txt') as inputFile:
    for line in inputFile:
        inputList.append(line.strip())

interpolationList = []
row = 0
for line in designLineList:
    for index in find_all(line, 'nop'):
        interpolationList.append(Interpolation(InterpolationType.INSTRUCTION, row, index))
    for index in find_all(line, '0xFFFFFFFF'):
        interpolationList.append(Interpolation(InterpolationType.HEX_8, row, index + 2))
    for index in find_all(line, '0xAA'):
        interpolationList.append(Interpolation(InterpolationType.HEX_2, row, index + 2))
    for index in find_all(line, 'True'):
        interpolationList.append(Interpolation(InterpolationType.BOOLEAN, row, index))
    row += 1
interpolationList.sort(key=getTerminalAddress)

inputIter = iter(inputList)
disassemblerInputList = []
hexCharacterInputList = []
booleanTextInputList = []
dataList = []
for interpolation in interpolationList:
    address = getTerminalAddress(interpolation)
    length = None
    source = None
    if interpolation.type is InterpolationType.INSTRUCTION:
        length = 32
        disassemblerInputList.append('nextTerminalAddress >= {} && nextTerminalAddress < {} ? {}'.format(address, address + length, next(inputIter)))
        source = 'disassemblerOutput'
    elif interpolation.type is InterpolationType.HEX_8:
        length = 8
        hexCharacterInputList.append('nextTerminalAddress >= {} && nextTerminalAddress < {} ? {}[31 - 4 * (nextTerminalAddress - {}) -: 4]'.format(address, address + length, next(inputIter), address))
        source = 'hexCharacterOutput'
    elif interpolation.type is InterpolationType.HEX_2:
        length = 2
        hexCharacterInputList.append('nextTerminalAddress >= {} && nextTerminalAddress < {} ? {}[7 - 4 * (nextTerminalAddress - {}) -: 4]'.format(address, address + length, next(inputIter), address))
        source = 'hexCharacterOutput'
    elif interpolation.type is InterpolationType.BOOLEAN:
        length = 5
        booleanTextInputList.append('nextTerminalAddress >= {} && nextTerminalAddress < {} ? {}'.format(address, address + length, next(inputIter)))
        source = 'booleanTextOutput'
    dataList.append('nextTerminalAddress >= {} && nextTerminalAddress < {} ? {}[{} - 8 * (nextTerminalAddress - {}) -: 8]'.format(address, address + length, source, length * 8 - 1, address))

def printLineList(firstLine, lineList, lastLine = None):
    print(firstLine)
    isFirst = True
    for line in lineList:
        print('		', end='')
        if isFirst:
            isFirst = False
        else:
            print(': ', end='')
        print(line)
    if lastLine:
        print('		: {};'.format(lastLine))

printLineList('wire [31:0] disassemblerInput =', disassemblerInputList, '32\'hFFFFFFFF')
print()
printLineList('wire [3:0] hexCharacterInput =', hexCharacterInputList, '4\'hFF')
print()
printLineList('wire booleanTextInput =', booleanTextInputList, '1\'b1')

print()

print('wire [{}:0] backgroundText = {{'.format(2400 * 8 - 1))
isFirst = True
for line in designLineList:
    if isFirst:
        isFirst = False
    else:
        print(',')
    print('		"{}"'.format(line), end='')
print('''
};''')

print()

printLineList('terminalWriteData <=', dataList, 'backgroundText[{} - 8 * nextTerminalAddress -: 8]'.format(2400 * 8 - 1))
