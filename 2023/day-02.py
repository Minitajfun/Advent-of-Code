import aoc
import re

values = aoc.fetch(2023, 2)

a1:int=0
a2:int=0

for gameid in range(100):
    n = {
        'red': 0,
        'green': 0,
        'blue': 0
    }
    game = values[gameid].split(':')[1]
    rgx = re.findall(r'(\d+) (red|green|blue)', game)
    for rvl in rgx:
        n[rvl[1]] = max(n[rvl[1]], int(rvl[0]))
    if n['red'] <= 12 and n['green'] <= 13 and n['blue'] <= 14:
        a1 = a1 + gameid + 1
    a2 = a2 + (n['red'] * n['green'] * n['blue'])
    print(n)

print('Part 1:', a1)
print('Part 2:', a2)