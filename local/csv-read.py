import csv
import os

os.system('clear')

with open('/Users/steve/Dropbox/Digital Ocean/local/shares-py.csv') as f:
    csv_reader = csv.reader(f, delimiter=',')
    rows = 0

    # Column indices
    filesystem=0
    protocol=1
    bonjour=2
    netbios=3
    ip=4
    name=5
    volume=6
    mountpoint=7

    for col in csv_reader:
        if rows == 0:
        #    print(f'Column names are {",".join(col)}')
            rows += 1
        else:
        #    print(f'Share {rows}')
            print(f'sudo mount -t { col[filesystem] } { col[protocol] }://steve@{ col[bonjour] }/{ col[volume] } /Volumes/{ col[mountpoint] }')
            rows += 1
    #print(f'Processed {rows} lines.')
