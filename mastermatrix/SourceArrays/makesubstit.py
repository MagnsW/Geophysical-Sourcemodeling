import sys
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET


arrayname = sys.argv[1]
filename = arrayname + ".G2X"
subarrays = []

print("Opening file: " + filename)
f=open(filename)
lines = f.read().splitlines()
f.close()
for i, line in enumerate(lines):
    if "SUB" in line:
        line = line.replace(" ", "")
        #print(i, line)
        start = line.find(">", 0, 30)
        end = line.find("<", 5)
        #print(start, end)
        sub = line[start+1:end]
        subarrays.append(sub)
print(subarrays)

def getsubarray(subarray):
    gunlabels = []
    gunvolumes = []
    activation = []
    filename = subarray + ".G1X"
    tree = ET.parse(filename)
#    root = tree.getroot()
    for elem in tree.iter():
        #print(elem.tag, elem.attrib, elem.text)
        #print(elem.attrib.get('ID'), elem.text)
        if elem.attrib.get('ID') == 'GunLabel':
#            print(elem.text)
            gunlabels.append(elem.text)
        if elem.attrib.get('ID') == 'GunVolume':
            gunvolumes.append(elem.text)
        if elem.attrib.get('ID') == 'GunActivation':
            #print(elem.text)
            activation.append(elem.text)
#    print(gunlabels)
#    for i in range(0, len(gunlabels)):
#        print(gunlabels[i], gunvolumes[i], activation[i])
    return [gunlabels, gunvolumes, activation]
        
#    for elem in root:
#        for subelem in elem:
#            print(subelem.text)

def identsubst(arraydef):
    substitutions = []
    sparevols = []
    for i, subarray in enumerate(arraydef):
        print("subarray: " + str(i+1))
#        print(subarray)
        for j, activation in enumerate(subarray[2]):
            if activation == '0':
                print(subarray[0][j], subarray[1][j], activation)
                sparevols.append([str(i+1), subarray[0][j], subarray[1][j]])
    print(sparevols)
    for k, subarray in enumerate(arraydef):
        print("subarray: " + str(k+1))
        for l, activation in enumerate(subarray[2]):
            for spare in sparevols:
                if subarray[1][l] == spare[2] and activation == '1':
                   print("Guns that can be substituted: " + subarray[0][l], subarray[1][l], activation + " with: " + spare[0], spare[1])
                   substitutions.append([[str(k+1), subarray[0][l]], [spare[0], spare[1]]])
#            if activation == '1' and subarray[1][l] in sparevols:
#                print("Guns that can be substituted: " + subarray[0][l], subarray[1][l], activation)
    for substitution in substitutions:
        print(substitution)
    return substitutions
#        for gunlabel in subarray:
#            print(gunlabel)

def makesubstitution(substitution, postfix):
    print("make substitution")
    print(substitution)
    turnoff = False
    spareon = False
    for i, subarray in enumerate(subarrays):
        subno = i+1
        print(subno, subarray)
        filename1 = subarray + ".G1X"
        tree1 = ET.parse(filename1)
        for elem in tree1.iter():
            #print(elem.tag, elem.attrib, elem.text)
            #print(elem.attrib.get('ID'), elem.text)
            if elem.attrib.get('ID') == 'GunLabel':
                gunlabel = elem.text
                #print(gunlabel)
                #print("subs: " + substitution[0][0])
                if str(subno) == substitution[0][0] and gunlabel == substitution[0][1]:
                    print("Will switch off gun: " + str(subno) +  gunlabel) 
                    turnoff = True
                else:
                    turnoff = False
                if str(subno) == substitution[1][0] and gunlabel == substitution[1][1]:
                    print("Will switch on gun: " + str(subno) +  gunlabel) 
                    spareon = True
                else:
                    spareon = False
            if turnoff and elem.attrib.get('ID') == 'GunActivation':
                elem.text = '0'
            if spareon and elem.attrib.get('ID') == 'GunActivation':
                elem.text = '1'
        tree1.write(subarray + postfix + ".G1X")
    tree2 = ET.parse(filename)
    for elem in tree2.iter():
        if elem.text in subarrays:
            sub = elem.text
            elem.text = sub + postfix
    tree2.write(arrayname + postfix + ".G2X")
    #read/write subarray 1-3
    
    #read/write full array
        

arraydef = []
for subarray in subarrays:
    arraydef.append(getsubarray(subarray))
#print(arraydef)

validsubstitutions = identsubst(arraydef)
for n, validsubstitution in enumerate(validsubstitutions):
    postf = "_" + str(n).zfill(2)
    print(postf)
    makesubstitution(validsubstitution, postf)
#makesubstitution(validsubstitutions[0], '_01')
