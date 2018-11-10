#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov  9 20:46:11 2018

@author: urp
"""

import numpy as np
import matplotlib.pyplot as plt

import pandas as pd
database_file="data/world_cities_dk.csv"
db_dk = pd.read_csv(database_file)

# Copenhagen = København, som den eneste
def city2latlon(name="Herning"):
    # print(db.head())
    i=db_dk[db_dk.AccentCity==name]
    if i.size > 0:
        i0=i.iloc[0]
        return i0.Latitude, i0.Longitude
    else:
        return None,None

def plotCph():
    import pandas as pd
    database_file="data/kbh_adr.csv"
    db = pd.read_csv(database_file) 
    plt.scatter(db.longitude,
                db.latitude ,
                c=db.postnummer,
                marker='.',
                alpha=0.4)

def plotDK():
    import pandas as pd
    database_file="data/world_cities_dk.csv"
    db = pd.read_csv(database_file)
    lon = db.Longitude
    lat = db.Latitude

    plt.scatter(lon,
                lat,
                #s=X4[:,2]/scl,
                #c=clu_predict,
                marker='.',
                alpha=0.4)

def plotHerning():
    plotDK()
    lat,lon = city2latlon("Herning")
    plt.scatter(lon,lat,marker='x',c='r')

ofile = open("data/birthplace_latlon.csv", "w")
ofile.write("id,lat,lon\n")

#col_names = 
#odf = pd.DataFrame()

database_dir = "data/hack4dk_kbharkiv_police_example_csv/"
database_file = database_dir + "hack4dk_police_person.example.csv"
db = pd.read_csv(database_file)
db.head()
#bp = db.birthplace
for index, row in db.iterrows():
    birthplace = row['birthplace']
    i = row['id']
    lat,lon = city2latlon(birthplace)
    #print(birthplace,lat,lon)
    if type(lat)==np.float64:
        ofile.write("%i,%f,%f\n"%(i,lat,lon))
    else:
        ofile.write("%i,None,None"%i)

ofile.close()

#lat,lon = city2latlon("Ølby")
#print( "%f,%f\n"%(lat,lon) )
#lat,lon = city2latlon(name=bp)
