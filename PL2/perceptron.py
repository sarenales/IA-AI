# perceptron.py
# -------------



# Perceptron implementation
import util
import pickle
import DataLoad

PRINT = True

class PerceptronClassifier:
    """
    Perceptron classifier.

    Note that the variable 'datum' in this code refers to a counter of features
    (not to a raw samples.Datum).
    """
    def __init__( self, legalLabels, max_iterations):
        self.legalLabels = legalLabels
        self.type = "perceptron"
        self.max_iterations = 5 # max_iterations
        self.weights = {}
        for label in legalLabels:
            self.weights[label] = util.Counter() # this is the data-structure you should use

    def setWeights(self, weights):
        assert len(weights) == len(self.legalLabels)
        self.weights = weights

    
        
    def train( self, trainingData, trainingLabels, validationData, validationLabels):
        """
        The training loop for the perceptron passes through the training data several
        times and updates the weight vector for each label based on classification errors.
        See the project description for details.

        Use the provided self.weights[label] data structure so that
        the classify method works correctly. Also, recall that a
        datum is a counter from features to values for those features
        (and thus represents a vector a values).
        """
      
        trainingData=DataLoad.loadTrainingData()
        trainingLabels=DataLoad.loadTrainingLabels()
        self.features = trainingData[0].keys() # could be useful later
        # DO NOT ZERO OUT YOUR WEIGHTS BEFORE STARTING TRAINING, OR
        # THE AUTOGRADER WILL LIKELY DEDUCT POINTS.
        
        print("Length trainingData: ", len(trainingData)) # clases a entrenar
        #print(trainingData[0])
        print("Length trainingLabels: ", len(trainingLabels)) # clases reales
        #print(trainingLabels)


        for iteration in range(self.max_iterations):
            print ("Starting iteration ", iteration, "...")
            for i in range(len(trainingData)):
                #obtener clase a predecir
                clase_predecir = self.classify2([trainingData[i]])[0]
                #obtener clase real
                clase_real = trainingLabels[i]
                #si la prediccion es mala, actualizamos pesos
                if clase_predecir != clase_real:
                    self.weights[clase_predecir]-= trainingData[i]
                    self.weights[clase_real] += trainingData[i]
               
                
            
        
    def classify(self, data ):
        """
        Classifies each datum as the label that most closely matches the prototype vector
        for that label.  See the project description for details.

        Recall that a datum is a util.counter...
        """
        
        data=DataLoad.loadValidationData()
        
        guesses = []
        for i in data:
            v = util.Counter()
            for j in self.weights:
                #multiplicar por pesos
                v[j] = self.weights[j]*i
            guesses.append(v.argMax())          
        return guesses
    
    def classify2(self, data ):
        """
        Classifies each datum as the label that most closely matches the prototype vector
        for that label.  See the project description for details.

        Recall that a datum is a util.counter...
        """
        
        guesses = []
        for i in data:
            # el counter realiza un seguimiento de los recuentos
            # creamos un counter por cada instancia(imagen) y en este se guarda 
            # los "votos" de los diferentes numeros que puede ser la instancia.
            v = util.Counter()
            for j in self.weights:
                #multiplicar por pesos
                v[j] = self.weights[j]*i
            guesses.append(v.argMax()) # argMax es una funcion del couter      
        return guesses
        
        
