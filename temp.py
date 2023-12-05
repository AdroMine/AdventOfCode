
    def djikstra(self, start_point = None) -> Dict[str, float]:
        if start_point is None:
            start_point = self.nodes[0]
        
        distances = {vertex: float('infinity') for vertex in self.graph}
        distances[start_point] = 0
        
        pq = [(0, start_point)]
        
        while len(pq) > 0:
            cur_dist, cur_vx = hq.heappop(pq)
            
            if cur_dist > distances[cur_vx]:
                continue
            
            for nbr, wt in self.graph[cur_vx]:
                dist = cur_dist + wt
                
                if dist < distances[nbr]:
                    distances[nbr] = dist
                    hq.heappush(pq, (dist, nbr))
        
        return distances