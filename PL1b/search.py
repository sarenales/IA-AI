# search.py

"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

import util

class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]

def depthFirstSearch(problem):
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print("Start:", problem.getStartState())
    print("Is the start a goal?", problem.isGoalState(problem.getStartState()))
    print("Start's successors:", problem.getSuccessors(problem.getStartState()))
    """
    visitados = []
    adyacentes = util.Stack()

    adyacentes.push((problem.getStartState(), [], 0))

    while not adyacentes.isEmpty(): 
        sacarNodo = adyacentes.pop()
        if sacarNodo[0] not in visitados:
            if problem.isGoalState(sacarNodo[0]):
                resultado = sacarNodo[1]
                break;
            else:
                visitados.append(sacarNodo[0])
                x = problem.getSuccessors(sacarNodo[0])
                for hijo, mov_hijo, hijo_coste in x:
                    if (hijo not in visitados):
                        resultado = adyacentes.push((hijo, sacarNodo[1]+[mov_hijo]))

    return resultado
   # util.raiseNotDefined()

def breadthFirstSearch(problem):
    """Search the shallowest nodes in the search tree first."""
    "*** YOUR CODE HERE ***"
    visitados = []
    adyacentes = util.Queue()

    adyacentes.push((problem.getStartState(), []))
    
    visitados.append(problem.getStartState())

    while (not adyacentes.isEmpty()): 
    
        #sacamos nodo
        sacarNodo = adyacentes.pop()
        
        if (problem.isGoalState(sacarNodo[0])):
            return sacarNodo[1]
            

        #print("sig coordenada\n", sacarNodo[0][0])        
        
        # recorremos los sucesores
        for sucesor in problem.getSuccessors(sacarNodo[0]):
            if(sucesor[0] not in visitados):
                visitados.append(sucesor[0])
                adyacentes.push((sucesor[0], sacarNodo[1]+[sucesor[1]]))
                #print("resultado", sacarNodo[1])
    return sacarNodo[1]

def uniformCostSearch(problem):
    """Search the node of least total cost first."""
    from util import PriorityQueue
    visitados = []
    adyacentes = util.PriorityQueue()

    adyacentes.push((problem.getStartState(), [], 0), 0)

    while not adyacentes.isEmpty(): 
        sacarNodo = adyacentes.pop()
        if sacarNodo[0] not in visitados:
            if problem.isGoalState(sacarNodo[0]):
                resultado = sacarNodo[1]
                break
            else:
                visitados.append(sacarNodo[0])
                x = problem.getSuccessors(sacarNodo[0])
                for hijo, mov_hijo, hijo_coste in x:
                    if (hijo not in visitados):
                        resultado = adyacentes.push((hijo, sacarNodo[1]+[mov_hijo], sacarNodo[2]+hijo_coste),sacarNodo[2]+hijo_coste) 

    return resultado

def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    "*** YOUR CODE HERE ***"
    
    # BRANCH & BOUND
    from util import PriorityQueue
    
    # construimos una lista de caminos parciales
    tree = PriorityQueue()
    # anadimos nodo raiz
    tree.push((problem.getStartState(),[],0),0) # estado, camino, coste + costeheuristicoAcumulado   
    visitados = []
    
    # hasta que la lista este vacia o el camino alcance el nodo objetivo 
    # y el coste del camino <= que el coste de cualquier otro camino
    while not tree.isEmpty():
        # eliminar primer camino de la lista
        (siguiente, camino, cost) = tree.pop()
        
        #print("siguiente", siguiente)
        if problem.isGoalState(siguiente):
            return camino
        
        # formar nuevos caminos a partir del eliminado        
        if siguiente not in visitados:        
            visitados.append(siguiente)
            adyacentes = problem.getSuccessors(siguiente)
            # anadir tanto caminos como hijos tenga el ultimo nodo de este camino
            for hijo in adyacentes:
                if hijo[0] not in visitados:
                    heuristicost = cost + hijo[2] + heuristic(hijo[0], problem)
                    tree.push((hijo[0],camino+[hijo[1]], cost+hijo[2]), heuristicost)
    return camino
                    
    
    
   # util.raiseNotDefined()


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch
