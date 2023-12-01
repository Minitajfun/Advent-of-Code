import aoc
import re

values = aoc.fetch(2023, 1)

a1:int = 0
a2:int = 0

def fixNum(value) -> str:
    match value:
        case 'zero': return '0'
        case 'one': return '1'
        case 'two': return '2'
        case 'three': return '3'
        case 'four': return '4'
        case 'five': return '5'
        case 'six': return '6'
        case 'seven': return '7'
        case 'eight': return '8'
        case 'nine': return '9'
        case _: return value

for line in values:
    nums1 = re.findall('\d', line)
    nums2 = [fixNum(x) for x in re.findall(r"(?=(\d|one|two|three|four|five|six|seven|eight|nine|zero))", line)]
    a1 = a1 + int(nums1[0]+nums1[-1])
    a2 = a2 + int(nums2[0]+nums2[-1])

print('Part 1:', a1)
print('Part 2:', a2)