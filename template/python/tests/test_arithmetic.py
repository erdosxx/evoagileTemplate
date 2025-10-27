from prj_name.arithmetic import add, mul


def test_add():
    assert add(1, 2) == 3


def test_mul():
    assert mul(2, 2) == 4


def test_mul2():
    assert mul(2, 0) == 0
