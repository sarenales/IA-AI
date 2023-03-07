# multiAgents.py
# --------------


from util import manhattanDistance
from game import Directions
import random, util

from game import Agent

class ReflexAgent(Agent):
    """
    A reflex agent chooses an action at each choice point by examining
    its alternatives via a state evaluation function.

    The code below is provided as a guide.  You are welcome to change
    it in any way you see fit, so long as you don't touch our method
    headers.
    """


    def getAction(self, gameState):
        """
        You do not need to change this method, but you're welcome to.

        getAction chooses among the best options according to the evaluation function.

        Just like in the previous project, getAction takes a GameState and returns
        some Directions.X for some X in the set {NORTH, SOUTH, WEST, EAST, STOP}
        """
        # Collect legal moves and successor states
        legalMoves = gameState.getLegalActions()

        # Choose one of the best actions
        scores = [self.evaluationFunction(gameState, action) for action in legalMoves]
        bestScore = max(scores)
        bestIndices = [index for index in range(len(scores)) if scores[index] == bestScore]
        chosenIndex = random.choice(bestIndices) # Pick randomly among the best

        "Add more of your code here if you want to"

        return legalMoves[chosenIndex]

    def evaluationFunction(self, currentGameState, action):
        """
        Design a better evaluation function here.

        The evaluation function takes in the current and proposed successor
        GameStates (pacman.py) and returns a number, where higher numbers are better.

        The code below extracts some useful information from the state, like the
        remaining food (newFood) and Pacman position after moving (newPos).
        newScaredTimes holds the number of moves that each ghost will remain
        scared because of Pacman having eaten a power pellet.

        Print out these variables to see what you're getting, then combine them
        to create a masterful evaluation function.
        """
        # Useful information you can extract from a GameState (pacman.py)
        successorGameState = currentGameState.generatePacmanSuccessor(action)
        newPos = successorGameState.getPacmanPosition()
        newFood = successorGameState.getFood()
        newGhostStates = successorGameState.getGhostStates()
        newScaredTimes = [ghostState.scaredTimer for ghostState in newGhostStates]

        "*** YOUR CODE HERE ***"
        """
        distanciafantasmas = []
        # buscamos la distancia del fantasma mas cercano
        for ghost in newGhostStates:
            distanciafantasmas.append(manhattanDistance(ghost.configuration.pos, newPos))
        mascercag = min(distanciafantasmas)
        
        #si esta muy cerca, bajamos puntuacion
        if mascercag < 3:
                heuristicoGhost = -10
        else:
                heuristicoGhost = 0
        
        
        # volcar las posiciones de la comida en una lista
        # You can call foodGrid.asList() to get a list of food coordinates instead.
       
        todalacomida = newFood.asList()
        

        
        if len(todalacomida)>0:
                comidaposible = todalacomida[0]
                
                # obtener la dist de la siguiente comida 
                dist = util.manhattanDistance(newPos, todalacomida[0])
                
                # comparar con el minimo encontrado
                for food in todalacomida:
                    distm = util.manhattanDistance(newPos, food)
                    if distm < dist:
                        dist = distm
                        comidaposible = food
                # obtenemos el minimo 
                valorHeuristico = util.manhattanDistance(newPos, comidaposible)
                valorHeuristico = 10/valorHeuristico
        else: # si no hay comida--->0
                 valorHeuristico =  0
        
        return successorGameState.getScore() + (valorHeuristico) + heuristicoGhost
        """
        listaComida = newFood.asList()
        
        distMinFantasma = float('inf')
        distMinComida = float('inf')
        
        for fantasma in newGhostStates:
                distanciaFantasma = util.manhattanDistance(newPos, fantasma.getPosition())
                if distanciaFantasma < distMinFantasma:
                        distMinFantasma = distanciaFantasma
        for comida in listaComida:
                distanciaComida = util.manhattanDistance(newPos, comida)
                if distanciaComida < distMinComida:
                        distMinComida = distanciaFantasma
        score = 0.0
        if distMinFantasma < 2:
                score -=10
        elif distMinComida < 5:
                score -=1
                
        if listaComida == []:
                score +=10
        else:
                if distMinComida != 0:
                        score += 1.0/distMinComida
                        score += 10 * (len(listaComida))
                        
        return score+successorGameState.getScore()
        
        
def scoreEvaluationFunction(currentGameState):
    """
    This default evaluation function just returns the score of the state.
    The score is the same one displayed in the Pacman GUI.

    This evaluation function is meant for use with adversarial search agents
    (not reflex agents).
    """
    return currentGameState.getScore()

class MultiAgentSearchAgent(Agent):
    """
    This class provides some common elements to all of your
    multi-agent searchers.  Any methods defined here will be available
    to the MinimaxPacmanAgent, AlphaBetaPacmanAgent & ExpectimaxPacmanAgent.

    You *do not* need to make any changes here, but you can if you want to
    add functionality to all your adversarial search agents.  Please do not
    remove anything, however.

    Note: this is an abstract class: one that should not be instantiated.  It's
    only partially specified, and designed to be extended.  Agent (game.py)
    is another abstract class.
    """

    def __init__(self, evalFn = 'scoreEvaluationFunction', depth = '2'):
        self.index = 0 # Pacman is always agent index 0
        self.evaluationFunction = util.lookup(evalFn, globals())
        self.depth = int(depth)

class MinimaxAgent(MultiAgentSearchAgent):
    """
    Your minimax agent (question 2)
    """

    def getAction(self, gameState):
        """
        Returns the minimax action from the current gameState using self.depth
        and self.evaluationFunction.

        Here are some method calls that might be useful when implementing minimax.

        gameState.getLegalActions(agentIndex):
        Returns a list of legal actions for an agent
        agentIndex=0 means Pacman, ghosts are >= 1

        gameState.generateSuccessor(agentIndex, action):
        Returns the successor game state after an agent takes an action

        gameState.getNumAgents():
        Returns the total number of agents in the game

        gameState.isWin():
        Returns whether or not the game state is a winning state

        gameState.isLose():
        Returns whether or not the game state is a losing state
        """
        "*** YOUR CODE HERE ***"
        _, mov = self.minimax(gameState, self.depth,0)
       # _, mov = self.value(gameState,self.depth, 0)
        return mov

        #util.raiseNotDefined()
    def minimax(self, gameState, depth, indiceAgente):
    
    
        numFantasmas = gameState.getNumAgents() - 1
        Movimientos = gameState.getLegalActions(indiceAgente)
        
        maxmovs = 0
        minmovs = 0
        
        # caso basico, si el estado es terminal(ganar o perder)
        if gameState.isWin() or gameState.isLose() or depth == 0:
                return self.evaluationFunction(gameState), 0
        # caso general, recursivo.
        if indiceAgente == 0: # si es pacman
                maxVal = float("-inf")
                #obtenemos el mov con valor max
                for mov in Movimientos:
                        points, _ = self.minimax(gameState.generateSuccessor(indiceAgente, mov), depth, indiceAgente+1)
                        if points > maxVal:
                                maxVal = points
                                maxmovs = mov
                return maxVal, maxmovs
        else: # fantasmas
                minVal = float("inf")
                if indiceAgente == numFantasmas:
                        depth = depth - 1
                        indiceAgente = -1
                #obtener el movimiento con el minimo valor
                for mov in Movimientos:
                        points, _ = self.minimax(gameState.generateSuccessor(indiceAgente,mov),depth,indiceAgente+1)
                        if points < minVal:
                                minVal = points
                                minimovs = mov 
                return minVal, minmovs

class AlphaBetaAgent(MultiAgentSearchAgent):
    """
    Your minimax agent with alpha-beta pruning (question 3)
    """

    def getAction(self, gameState):
        """
        Returns the minimax action using self.depth and self.evaluationFunction
        """
        "*** YOUR CODE HERE ***"
        _, mov = self.aphabeta(gameState, self.depth,0, -100000, 10000)
        return mov

    def aphabeta(self, gameState, depth, indiceAgente,alpha, beta):
    
    
        # lista de movimientos del agente
        Movimientos = gameState.getLegalActions(indiceAgente)
        
        maxmovs = 0
        minmovs = 0
      
        #obtenemos el num de fantasmas
        numFantasmas = gameState.getNumAgents()-1
        depth = self.depth
        
        
        #Si el estado es terminal(ganar o perder), devolver la utilidad del estado.
        if gameState.isWin() or gameState.isLose() or depth == 0: 
                return self.evaluationFunction(gameState), 0
            
        indiceAgente = self.index   
        betaMax = 0
        betaMin = 0
        if indiceAgente == 0:# si es pacman
                return self.maxValueAB(gameState, depth, indiceAgente,alpha, beta,maxmovs,Movimientos)
        else: # si es un fantasma
                return self.minValueAB(gameState, depth, indiceAgente,alpha, beta, minmovs,Movimientos, numFantasmas)
        
        
        
        
    def maxValueAB(self, state, depth, indiceAgente, alpha, beta, maxmovs,Movimientos):
        v = float("-inf")
        # borrador foto, bucle de profundidaes en funcion del num de fastasmas
        # obtenemos el maximo
        for accion in Movimientos:
                puntos, _ = self.aphabeta(state.generateSuccessor(indiceAgente, accion),depth, indiceAgente+1, alpha, beta)
                if puntos > v:
                    v = puntos
                    maxmovs = accion
                alpha = max(alpha, puntos)
                if beta < alpha:
                    break
        return v, maxmovs

    def minValueAB(self, state, depth, indiceAgente, alpha, beta, minmovs,Movimientos, numFantasmas):
        v = float("-inf")
        if indiceAgente == numFantasmas:
            depth = depth - 1
            indiceAgente = -1
        # obtenemos el minimo
        for accion in Movimientos:
                puntos, _ = self.aphabeta(state.generateSuccessor(indiceAgente, accion),depth, indiceAgente+1, alpha, beta)
                if puntos < v:
                    v = puntos
                    minmovs = accion
                alpha = min(alpha, puntos)
                if beta < alpha:
                    break
        return v, minmovs

class ExpectimaxAgent(MultiAgentSearchAgent):
    """
      Your expectimax agent (question 4)
    """

    def getAction(self, gameState):
        """
        Returns the expectimax action using self.depth and self.evaluationFunction

        All ghosts should be modeled as choosing uniformly at random from their
        legal moves.
        """
        "*** YOUR CODE HERE ***"
        util.raiseNotDefined()

def betterEvaluationFunction(currentGameState):
    """
    Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
    evaluation function (question 5).

    DESCRIPTION: <write something here so we know what you did>
    """
    "*** YOUR CODE HERE ***"
    util.raiseNotDefined()

# Abbreviation
better = betterEvaluationFunction
