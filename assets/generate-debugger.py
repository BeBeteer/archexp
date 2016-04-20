#!/usr/bin/env python3

designLineList = []
with open(input("Design file: ")) as designFile:
    for line in designFile:
        designLineList.append(line.rstrip().ljust(80))

print('				: {')
isFirst = True
for line in designLineList:
    if isFirst:
        isFirst = False
    else:
        print(',')
    print('					"{}"'.format(line), end='')
print('''
				}[8 * getDistanceFromTerminalAddress(0, 0) +: 8]''')
