# code really slow, might find faster solution later

import aoc
import re

values = aoc.fetch(2023, 4)
a1:int=0
a2:int=0

def godhatesme(n:int, p2:bool):
    global a1
    global a2
    a2 = a2 + 1
    ltr = values[n].split(': ')[1].split(' | ')
    wn = set([int(x) for x in re.findall(r'\d+', ltr[0])])
    mn = set([int(x) for x in re.findall(r'\d+', ltr[1])])
    if len(wn.intersection(mn)) > 0:
        if not p2:
            a1 = a1 + pow(2, len(wn.intersection(mn))-1)
        for m in range(len(wn.intersection(mn))):
            godhatesme(n+m+1, True)


for n in range(len(values)):
    print(n, '/', len(values))
    godhatesme(n, False)

print()
print('Part 1:', a1)
print('Part 2:', a2)