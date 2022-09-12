from d3_solution import * 

def test_p1():
    assert d3part1('^v') == 2
    assert d3part1('^>v<') == 4
    assert d3part1('^v^v^v^v^v') == 2
    

def test_p2():
    assert d3part2('^v') == 3
    assert d3part2('^>v<') == 3
    assert d3part2('^v^v^v^v^v') == 11
