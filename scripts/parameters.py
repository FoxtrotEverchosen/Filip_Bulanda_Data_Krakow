import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

"""
    Script works on data from DB saved as .csv file. Table does not require any specific shape. Data should be numerical.
        
    return: prints out the correlation matrix as well as heatmap based on that matrix
"""


# check if there exists a correlation between features like quantity, weight and delivery times

df = pd.read_csv('quan_wei_delivtime.csv')
pd.set_option('display.max_columns', None)
matrix = df.corr()
print(matrix)


plt.figure(figsize=(8, 7))
sns.heatmap(matrix, annot=True, cmap='coolwarm', center=0, square=True, linewidths=0.5, linecolor='k')
plt.title("Correlation Matrix", fontsize=16)
plt.xticks(rotation=45, ha='right', fontsize=10)
plt.yticks(fontsize=10)
plt.tight_layout()
plt.show()


# check if there exists a correlation between all the features
df2 = pd.read_csv('all.csv')
matrix2 = df2.corr()
print(matrix2)

pd.reset_option('display.max_columns')

plt.figure(figsize=(8, 7))
sns.heatmap(matrix2, annot=True, cmap='coolwarm', center=0, square=True, linewidths=0.5, linecolor='k')
plt.title("Correlation Matrix", fontsize=16)
plt.xticks(rotation=45, ha='right', fontsize=10)
plt.yticks(fontsize=10)
plt.tight_layout()
plt.show()

# found no correlation between (quality, weight) and delivery time. We only observer a significant
# correlation between delivery time and (driver_id and sector_id) which were already known from box plot.
# Broader cor.matrix didn't show any correlation either
