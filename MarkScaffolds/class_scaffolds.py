genes = []
origin = []
ori_gen = open("origin_genes_nucl_new_70.txt", 'r')
for line in ori_gen:
    line = line.strip()
    out = line.split('\t')
    genes.append(out[0])
    origin.append(out[1])

#counting amount of genes related to Cr or Co for each contig
Acontigs = {}
Bcontigs = {}
Ucontigs = {}

for num in range(len(genes)):
    each = genes[num].split('_@_')
    if origin[num] == "A":
        if not each[1] in Acontigs:
            Acontigs[each[1]] = 1
        else:
            Acontigs[each[1]] = Acontigs[each[1]]+1

    if origin[num] == "B":
        if not each[1] in Bcontigs:
            Bcontigs[each[1]] = 1
        else:
            Bcontigs[each[1]] = Bcontigs[each[1]]+1

    if origin[num] == "U":
        if not each[1] in Ucontigs:
            Ucontigs[each[1]] = 1
        else:
            Ucontigs[each[1]] = Ucontigs[each[1]]+1
stat_contigs = open("stat_contigs.txt",'w')


for each in set(list(Acontigs)+list(Bcontigs)+list(Ucontigs)):
    if not each in list(Bcontigs):
        Bcontigs[each] = 0
    if not each in list(Acontigs):
        Acontigs[each] = 0
    if not each in list(Ucontigs):
        Ucontigs[each] = 0
    stat_contigs.write(each+"\t")
    stat_contigs.write(str(Acontigs[each])+"\t")
    stat_contigs.write(str(Bcontigs[each])+"\t")
    stat_contigs.write(str(Ucontigs[each])+"\n")
stat_contigs.close()

cont = []
countA = []
countB = []

stat_contigs = open("stat_contigs.txt", 'r')
for line in stat_contigs:
    line = line.strip()
    line = line.split("\t")
    cont.append(line[0])
    countA.append(line[1])
    countB.append(line[2])
    
#A = Co, B = Cr
    
contigs_oriA = open("contigs_oriA.txt", 'w')
contigs_oriB = open("contigs_oriB.txt", 'w')
contigs_ori_unknown = open("contigs_ori_unknown.txt", 'w')
contigs_ori_any = open("contigs_ori_any.txt", 'w')
cont_oriA = []
cont_oriB = []
cont_unknown = []

for each in range(len(cont)):
    if int(countA[each]) > int(countB[each]):
        contigs_ori_any.write(cont[each]+"\t"+"A"+"\n")
        contigs_oriA.write(cont[each]+"\n")
        cont_oriA.append(cont[each])               
    elif int(countA[each]) < int(countB[each]):
        contigs_ori_any.write(cont[each]+"\t"+"B"+"\n")
        contigs_oriB.write(cont[each]+"\n")
        cont_oriB.append(cont[each])
    elif int(countA[each]) == int(countB[each]):       
        contigs_ori_any.write(cont[each]+"\t"+"U"+"\n")
        contigs_ori_unknown.write(cont[each]+"\n")
        cont_unknown.append(cont[each])
            
contigs_ori_any.close()
contigs_oriA.close()
contigs_oriB.close()
contigs_ori_unknown.close()
