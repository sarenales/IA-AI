# town.py



import shop


class Town:

    def __init__(self, shops, distances):
        """
            shops: List of FruitShop objects

            distances: Dictionary with keys as pairs (tuples) of names of places
            ('home' or name strings of FruitShops) and numbers for values which
            represent the distance between the two places in miles, e.g.
            {('home','shop1') : 1, ('home','shop2') : 1, ('shop1','shop2') : 2}
        """
        self.shops = shops
        self.distances = distances

    def getFruitCostPerPoundOnRoute(self, fruit, route):
        """
            fruit: Fruit string

            route: List of shop names
        Returns the best cost per pound of 'fruit' at any of the shops along 
        the route. If none of the shops carry 'fruit', returns None
        """
        routeShops = [shop for shop in self.shops if shop.getName() in route]
        costs = []
        for shop in routeShops:
            cost = shop.getCostPerPound(fruit)
            if cost is not None:
                costs.append(cost)
        if not costs:
            # None of the shops carry this fruit
            return None
        return min(costs)

    def allFruitsCarriedAtShops(self, orderList, shops):
        """
            orderList: List of (fruit, numPounds) tuples

            shops: List of shop names
        Returns whether all fruit in the order list can be purchased at at least
        one of these shops.
        """
        return None not in [self.getFruitCostPerPoundOnRoute(fruit, shops)
                            for fruit, _ in orderList]

    def getDistance(self, loc1, loc2):
        """
            loc1: A name of a place ('home' or the name of a FruitShop in town)

            loc2: A name of a place ('home' or the name of a FruitShop in town)
        Returns the distance between these two places in this town.
        """
        if (loc1, loc2) in self.distances:
            return self.distances[(loc1, loc2)]
        return self.distances[(loc2, loc1)]

    def getTotalDistanceOnRoute(self, route):
        """
            route: List of shop names
        Returns the total distance traveled by starting at 'home', going to 
        each shop on the route in order, then returning to 'home'
        """
        if not route:
            return 0
        totalDistance = self.getDistance('home', route[0])
        for i in xrange(len(route) - 1):
            totalDistance += self.getDistance(route[i], route[i + 1])
        totalDistance += self.getDistance(route[-1], 'home')
        return totalDistance

    def getPriceOfOrderOnRoute(self, orderList, route, gasCost):
        """
            orderList: List of (fruit, numPounds) tuples

            route: List of shop names

            gasCost: A number representing the cost of driving 1 mile
        Returns cost of orderList on this route. If any fruit are not available
        on this route, returns None. 
        """
        totalCost = self.getTotalDistanceOnRoute(route) * gasCost
        for fruit, numPounds in orderList:
            costPerPound = self.getFruitCostPerPoundOnRoute(fruit, route)
            if costPerPound is not None:
                totalCost += numPounds * costPerPound
        return totalCost

    def getShops(self):
        return self.shops
