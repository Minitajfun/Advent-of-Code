# my god this is awful

import aoc
import re

values = aoc.fetch(2023, 3)
values.insert(0, '.' * len(values[0]))
a1:int=0
a2:int=0

def g(v:list[str]) -> int:
    ns = []
    for x in re.finditer(r'\*', v[1]):
        ns.append(list())
        for z in re.finditer(r'(\d+)', v[1]):
            if z.end() == x.start() or z.start() == x.end():
                ns[-1].append(int(z.group(0))) 
        for z in list(re.finditer(r'(\d+)', v[0])) + list(re.finditer(r'(\d+)', v[2])):
            if z.end() >= x.start() and z.start() <= x.end():
                ns[-1].append(int(z.group(0))) 

    return sum([x[0]*x[1] for x in ns if len(x)==2])

for n in range(1, len(values)):
    for m in re.finditer(r'\d+', values[n]):
        for x in [x[m.start()-1:m.end()+1] for x in values[n-1:n+2]]:
            if len(re.findall(r'[^0-9.]+', x)) > 0:
                a1=a1+int(m.group(0))
    a2=a2+g(values[n-1:n+2])
print('Part 1:', a1)
print('Part 2:', a2)