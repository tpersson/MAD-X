import pandas as pd
import numpy as np
data = pd.read_table('out.txt')
print(np.mean(np.array(data['val'])))
