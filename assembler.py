def assemble(inFile, outFile):
    assemblyFile = open(inFile,'r')
    machineFile = open(outFile,'w')
    assembly = list(assemblyFile.read().split('\n'))
    lineNum = 0
    labelNum = 0

    aluOps = {'lw' : '000', 'sw' : '001', 'and' : '010', 'add' : '011', 'shift' : '100', 'set' : '101', 'xor' : '110', 'branch' : '111'}
    regFiles = {'r0' : '000', 'r1' : '001', 'r2' : '010', 'r3' : '011', 'r4' : '100', 'r5' : '101', 'r6': '110', 'r7' : '111'}

    #Convert each assembly line in machine code
    for line in assembly:
        arr = line.split(" ")
        # print(len(arr))
        cmd = aluOps[arr[0]]
        # if len(arr) < 3:
        if arr[1] not in regFiles:
            machCode = cmd + arr[1]
        elif len(arr) >= 3 and arr[2] in regFiles:
            machCode = cmd + regFiles[arr[1]] + regFiles[arr[2]]
        else:
            machCode = cmd + regFiles[arr[1]] + arr[2]
        machineFile.write(machCode + "\n")
    assemblyFile.close()
    machineFile.close()

assemble('assembly1.txt','prog1.txt')
assemble('assembly2.txt','prog2.txt')
assemble('assembly3.txt','prog3.txt')