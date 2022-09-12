from d11_solution import * 

def test_d11():
    assert find_nxt_pwd('abcdefgh') == 'abcdffaa'
    assert find_nxt_pwd('ghijklmn') == 'ghjaabcc'

