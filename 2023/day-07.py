# today's input was crap, just like my code

import aoc
import collections

values = aoc.fetch(2023, 7)
a1: int = 0
a2: int = 0

def obm(s: str, p2: bool = False) -> int:
    return [("AKQT98765432J" if p2 is True else "AKQJT98765432").index(c) for c in s]

tps = [[[], [], [], [], [], [], []], [[], [], [], [], [], [], []]]

for n in range(len(values)):
    h, b = values[n].split()
    match sorted(collections.Counter(h).values()):
        case [5]:
            tps[0][0].append((h, b))
        case [1, 4]:
            tps[0][1].append((h, b))
        case [2, 3]:
            tps[0][2].append((h, b))
        case [1, 1, 3]:
            tps[0][3].append((h, b))
        case [1, 2, 2]:
            tps[0][4].append((h, b))
        case [1, 1, 1, 2]:
            tps[0][5].append((h, b))
        case [1, 1, 1, 1, 1]:
            tps[0][6].append((h, b))

    if h == "JJJJJ":
        tps[1][0].append((h, b))
    else:
        hn = h.replace("J", h.replace("J", "")[list(collections.Counter(h if h == "JJJJJ" else h.replace("J", "")).values()).index(max(collections.Counter(h if h == "JJJJJ" else h.replace("J", "")).values()))])
        match sorted(collections.Counter(hn).values()):
            case [5]:
                tps[1][0].append((h, b))
            case [1, 4]:
                tps[1][1].append((h, b))
            case [2, 3]:
                tps[1][2].append((h, b))
            case [1, 1, 3]:
                tps[1][3].append((h, b))
            case [1, 2, 2]:
                tps[1][4].append((h, b))
            case [1, 1, 1, 2]:
                tps[1][5].append((h, b))
            case [1, 1, 1, 1, 1]:
                tps[1][6].append((h, b))


mr = len(values)
for n in range(7):
    for m in sorted(tps[0][n], key=lambda b: obm(b[0])):
        a1 = a1 + int(m[1]) * mr
        mr = mr - 1

mr = len(values)
for n in range(7):
    for m in sorted(tps[1][n], key=lambda b: obm(b[0], True)):
        a2 = a2 + int(m[1]) * mr
        mr = mr - 1

print("Part 1:", a1)
print("Part 2:", a2)
