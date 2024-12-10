import fileinput, re

ans = 0
tri_nums = [ (t - 1) * t // 2 for t in range( 24 + 1 ) ]
blueprints = [ list(map( int, re.findall( "-?\d+", l) ) ) for l in fileinput.input() ]
for _id, ore_c, clay_c, obs_c1, obs_c2, geo_c1, geo_c2 in blueprints:
    best = 0
    max_ore, max_clay, max_obs = max(ore_c, clay_c, obs_c1, geo_c1), obs_c2, geo_c2
    def dfs(time, robo_id, r1, r2, r3, r4, ore, clay, obs, geo):
        global best
        if (robo_id == 0 and r1 >= max_ore or
             robo_id == 1 and r2 >= max_clay or
             robo_id == 2 and (r3 >= max_obs or r2 == 0) or
             robo_id == 3 and r3 == 0 or
             geo + r4 * time + tri_nums[ time ] <= best):
            return
        while time:
            if robo_id == 0 and ore >= ore_c:
                for robo_id in range(4):
                    dfs(time - 1, robo_id, r1 + 1, r2, r3, r4, ore - ore_c + r1, clay + r2, obs + r3, geo + r4)
                return
            elif robo_id == 1 and ore >= clay_c:
                for robo_id in range(4):
                    dfs(time - 1, robo_id, r1, r2 + 1, r3, r4, ore - clay_c + r1, clay + r2, obs + r3, geo + r4)
                return
            elif robo_id == 2 and ore >= obs_c1 and clay >= obs_c2:
                for robo_id in range(4):
                    dfs(time - 1, robo_id, r1, r2, r3 + 1, r4, ore - obs_c1 + r1, clay - obs_c2 + r2, obs + r3, geo + r4)
                return
            elif robo_id == 3 and ore >= geo_c1 and obs >= geo_c2:
                for robo_id in range(4):
                    dfs(time - 1, robo_id, r1, r2, r3, r4 + 1, ore - geo_c1 + r1, clay + r2, obs - geo_c2 + r3, geo + r4)
                return
            time, ore, clay, obs, geo = time - 1, ore + r1, clay + r2, obs + r3, geo + r4
        best = max(best, geo)
    for g in range(4):
        dfs(24, g, 1, 0, 0, 0, 0, 0, 0, 0)
    ans += best * _id
print(ans)