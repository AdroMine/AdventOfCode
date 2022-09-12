import sys

in_file = sys.argv[1] if len(sys.argv) > 1 else r'2015\Day02\input.txt'

# read input, split on x
input = [map(int, line.strip().split('x')) for line in open(in_file).readlines()]

# convert to int and create tuples
# input = [[int(x[0]), int(x[1]), int(x[2])] for x in input]

wrap = 0
ribbon = 0
for item in input:
    l, w, h = item
    s1 = l * w
    s2 = w * h
    s3 = l * h
    wrap += 2*(s1 + s2 + s3) + min(s1, s2, s3)
    ribbon += l*w*h + 2 * sum(sorted(item)[0:2])

print(f"Wrapping paper required = {wrap}")
print(f"Ribbon required {ribbon}")