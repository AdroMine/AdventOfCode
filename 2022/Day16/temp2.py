def solve(flow, tunnels):

    states = [(1, "AA", "AA", 0, ("zzz",))]
    seen = {}
    best = 0

    max_flow = sum(flow.values())

    while len(states) > 0:

        current = states.pop()
        time, where, elephant, score, opened_s = current
        opened = {x for x in opened_s}

        if seen.get((time, where, elephant), -1) >= score:
            continue
        seen[(time, where, elephant)] = score

        if time == 26:
            best = max(best, score)
            continue

        # optim: if all valves are working, do nothing
        # with a friend this will happen...
        current_flow = sum(flow.get(where, 0) for where in opened)

        if current_flow >= max_flow:

            new_score = score + current_flow
            while time < 25:
                time += 1
                new_score += current_flow
            new_state = (time + 1, where, elephant, new_score, tuple(opened))
            states.append(new_state)
            continue

        # case 1: we open a valve here
        if flow[where] > 0 and where not in opened:
            opened.add(where)

            # case 1A: and the elephant open its valve too!
            if flow[elephant] > 0 and elephant not in opened:
                opened.add(elephant)

                new_score = score + sum(flow.get(where, 0) for where in opened)
                new_state = (time + 1, where, elephant, new_score, tuple(opened))

                states.append(new_state)

                opened.discard(elephant)

            # case 1B: the elephant goes somewhere
            new_score = score + sum(flow.get(where, 0) for where in opened)
            for option in tunnels[elephant]:
                new_state = (time + 1, where, option, new_score, tuple(opened))
                states.append(new_state)

            opened.discard(where)

        # case 2: we go somewhere else
        for option in tunnels[where]:

            # case 2A: and the elephant open its valve!
            if flow[elephant] > 0 and elephant not in opened:
                opened.add(elephant)

                new_score = score + sum(flow.get(where, 0) for where in opened)
                new_state = (time + 1, option, elephant, new_score, tuple(opened))

                states.append(new_state)

                opened.discard(elephant)

            # case 2B: and the elephant goes somewhere
            new_score = score + sum(flow.get(where, 0) for where in opened)
            for option_e in tunnels[elephant]:
                new_state = (time + 1, option, option_e, new_score, tuple(opened))
                states.append(new_state)

    return best


def main():

    flows = {}
    options = {}
    with open('input.txt') as in_f:
        for row in in_f:
            chunks = row.strip().replace('Valve ', '').split(' ')
            room, rest = chunks[0], ' '.join(chunks[1:])
            chunks = rest.replace('has flow rate=', '').split(';')
            flow, rest = int(chunks[0]), chunks[1]
            tunnels = rest.replace(' tunnels lead to valves ', '').replace(' tunnel leads to valve ', '').split(', ')

            flows[room] = flow
            options[room] = tunnels

    solution = solve(flows, options)

    print(solution)


if __name__ == "__main__":

    main()
