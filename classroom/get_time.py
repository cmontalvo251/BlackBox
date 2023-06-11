#!/usr/bin/python

from datetime import datetime
go = True
while go:
    val = input('Bib Number? ')
    if val == 'q':
        go = False
    now = datetime.now()
    dt_string = now.strftime('%H:%M:%S')
    print(val,dt_string)
