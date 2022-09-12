from d5_solution import * 
from d5_solution_regex import *

def test_d5p1():
    assert p1_nice('ugknbfddgicrmopn')
    assert p1_nice('aaa')
    assert not p1_nice('jchzalrnumimnmhp')
    assert not p1_nice('haegwjzuvuyypxyu')
    assert not p1_nice('dvszwmarrgswjxmb')
    assert p1_r_nice('ugknbfddgicrmopn')
    assert p1_r_nice('aaa')
    assert not p1_r_nice('jchzalrnumimnmhp')
    assert not p1_r_nice('haegwjzuvuyypxyu')
    assert not p1_r_nice('dvszwmarrgswjxmb')


def test_d5p2():
    assert p2_nice('qjhvhtzxzqqjkmpb')
    assert p2_nice('xyxy')
    assert not p2_nice('uurcxstgmygtbstg')
    assert not p2_nice('ieodomkazucvgmuy')
    assert p2_r_nice('qjhvhtzxzqqjkmpb')
    assert p2_r_nice('xyxy')
    assert not p2_r_nice('uurcxstgmygtbstg')
    assert not p2_r_nice('ieodomkazucvgmuy')