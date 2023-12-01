# Simple script for quick pull of input data

import requests
from tempfile import gettempdir
import os
import re

try:
    cookie_file = open(os.path.dirname(__file__) + '/cookie', 'r')
except FileNotFoundError:
    raise FileNotFoundError("Cookie file missing")
COOKIE = cookie_file.readline().strip()
if len(COOKIE) == 0:
    raise ValueError("Cookie missing from file")

def fetch(year:int, day:int) -> list[str]:
    if isCached(year, day):
        return [x.strip() for x in open(gettempdir() + '/aoc-input-{}-{}.txt'.format(year, day), 'r').readlines()]
    else:
        data = requests.get('https://adventofcode.com/{}/day/{}/input'.format(2023, 1), cookies={'session': COOKIE}).text
        open(gettempdir() + '/aoc-input-{}-{}.txt'.format(year, day), 'w').write(data)
        return [x.strip() for x in data.split('\n')][:-1]
        
def isCached(year:int, day:int) -> bool:
    return os.path.exists(gettempdir() + '/aoc-input-{}-{}.txt'.format(year, day))

def clearCache(year:int=None, day:int=None):
    for file in [x for x in os.listdir(gettempdir()) if re.match("^aoc-input-{}-{}\.txt$".format(year or r"\d{4}", day or r"\d{1,2}"), x) != None]:
        os.remove(gettempdir() + '/' + file)