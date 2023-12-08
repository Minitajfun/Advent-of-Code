# math? what's that?

import aoc
import re

values = aoc.fetch(2023, 6)
a1:int=1
a2:int=0

times = [int(x) for x in re.findall(r'\d+', values[0])]
dists = [int(x) for x in re.findall(r'\d+', values[1])]

time2 = int(''.join(map(str, times)))
dist2 = int(''.join(map(str, dists)))

for n in range(len(times)):
    win = 0
    for m in range(1, times[n]): # if it works, it works
        if (m*(times[n]-m) > dists[n]):
            win = win + 1
    a1 = a1 * win

for m in range(1, time2):
    if (m*(time2-m) > dist2):
        a2 = a2 + 1

print('Part 1:', a1)
print('Part 2:', a2)