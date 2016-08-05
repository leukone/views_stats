# -*- coding: utf-8 -*-
"""
Created on Fri Aug  5 11:18:16 2016

@author: ola
"""


import csv

remove_from = 0
remove_to = 1

with open("data.csv", "rb") as fp_in, open("data.csv", "wb") as fp_out:
    reader = csv.reader(fp_in, delimiter=",")
    writer = csv.writer(fp_out, delimiter=",")
    for row in reader:
        del row[remove_from:remove_to]
        writer.writerow(row)