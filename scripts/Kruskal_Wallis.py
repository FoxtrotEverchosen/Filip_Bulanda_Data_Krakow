import scipy as sp
import pandas as pd

"""
    input: Data from DB saved as .csv file. Csv table should look like: [sector_id] [delivery_time]. Of datatypes:
        [sector_id] - int/float
        [delivery_time] - float/int
        
    return: prints out the Kruskal Wallis test result for pairs: (sector 1, sector 2) and (sector 2, sector 3)
"""

df = pd.read_csv('sector_time.csv', delimiter=";").dropna()

# arrays with values for each sector
s1 = df[df['sector_id'] == 1]['delivery_time'].values
s2 = df[df['sector_id'] == 2]['delivery_time'].values
s3 = df[df['sector_id'] == 3]['delivery_time'].values

# From box chart we can see that sector 1 could belong to different population. Therefore, it will be compared to
# sector 2 (arbitrary choice since sector 2 and 3 seem to be similar). Sector 2 and Sector 3 will be compared to
# each other to validate the theory that they are statistically identical

result = sp.stats.kruskal(s1, s2, nan_policy='omit')
result2 = sp.stats.kruskal(s2, s3, nan_policy='omit')
mann_whitney = sp.stats.mannwhitneyu(s1, s2)

print("Result of Kruskal Wallis test for sector 1 and sector 2")
print(f"statistic= {result[0]}, p-value= {result[1]}")
print("Result of Kruskal Wallis test for sector 2 and sector 3")
print(f"statistic= {result2[0]}, p-value= {result2[1]}")
