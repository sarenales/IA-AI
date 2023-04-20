# mira.py
# -------


# Mira implementation
import DataLoad
import util
PRINT = True

class MiraClassifier:
    """
    Mira classifier.

    Note that the variable 'datum' in this code refers to a counter of features
    (not to a raw samples.Datum).
    """
    def __init__( self, legalLabels, max_iterations):
        self.legalLabels = legalLabels
        self.type = "mira"
        self.automaticTuning = False
        self.C = 0.001
        self.max_iterations = max_iterations
        self.initializeWeightsToZero()

    def initializeWeightsToZero(self):
        "Resets the weights of each label to zero vectors"
        self.weights = {}
        for label in self.legalLabels:
            self.weights[label] = util.Counter() # this is the data-structure you should use

    def train(self, trainingData, trainingLabels, validationData, validationLabels):
        "Outside shell to call your method. Do not modify this method."

        if (self.automaticTuning):
            Cgrid = [0.002, 0.004, 0.008]
        else:
            Cgrid = [self.C]

        return self.trainAndTune(trainingData, trainingLabels, validationData, validationLabels, Cgrid)

    
    
    
    def trainAndTune(self, trainingData, trainingLabels, validationData, validationLabels, Cgrid):
        
       
        # DO NOT ZERO OUT YOUR WEIGHTS BEFORE STARTING TRAINING, OR
        # THE AUTOGRADER WILL LIKELY DEDUCT POINTS.
        
        
        trainingData=DataLoad.loadTrainingData()
        validationData=DataLoad.loadValidationData()
        trainingLabels=DataLoad.loadTrainingLabels()
        validationLabels=DataLoad.loadValidationLabels()

        print("trainingData:", len(trainingData))
        print("trainingLabels:", len(trainingLabels))
        print("validationData:", len(validationData))
        print("validationLabels:", len(validationLabels))

        self.features = trainingData[0].keys()

        newWeights = self.weights.copy()
        for c in Cgrid:
            self.weights = newWeights.copy()
            for iteration in range(self.max_iterations):
                print ("Starting iteration ", iteration, "...")
                for i in range(len(trainingData)):
                    #obtener clase a predecir
                    clase_predecir = self.classify([trainingData[i]])[0]
                    #obtener clase real
                    clase_real = trainingLabels[i]
                    
                    #si la prediccion es mala, actualizamos pesos
                    if clase_predecir != clase_real:
                        
                        f = (trainingData[i]).copy()
                        #print(trainingData)
                        
                        t = min( ((self.weights[clase_predecir] - self.weights[clase_real]) * f + 1.0) / (2.0 * f * f ) ,c)
                        
                        #multiplicar por t los valores de trainingData
                        for j in f.keys():
                            f[j] *= t
                        
                        self.weights[clase_predecir]-= f
                        self.weights[clase_real] += f
            
                
        
        #self.weights = bestWeight        
              
    
    
             
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

