from Bio import Phylo
import re
import os

not_correct_fives = open("bad_Cbp_Cbp_Co_Cr_At_new_60.num", 'r')

not_correct = []
for i in not_correct_fives:
    not_correct.append(int(i))
fold_trees = os.listdir("tree/")

out_genes90 = open("origin_genes_nucl_new_90.txt", 'w')
out90 = []

out_genes70 = open("origin_genes_nucl_new_70.txt", 'w')
out70 = []

out_genes60 = open("origin_genes_nucl_new_60.txt", 'w')
out60 = []

for i in [x for x in range(len(fold_trees)/6) if x not in not_correct]:
    for file in fold_trees:
        if re.match("RAxML_bipartitionsBranchLabels."+str(i), file):
            tree = Phylo.read("tree/"+file, "newick")
            print(i)
            #check for support
            list_non_terminals = tree.get_nonterminals()
            con = []
            for clade in list_non_terminals:
                if clade.comment != None:
                    con.append(int(clade.comment))
            conmin = min(con)
            if conmin >= 90:                      
                list_terminals = tree.get_terminals()
                Genes_Cbp = []
                for clade in  list_terminals:
                    print(clade)
                    if re.match("AT.+", str(clade)):
                        AT = clade
                    elif re.match("Carubv.+", str(clade)):
                        Cr = clade
                    elif re.match("CapOri_SW_1\.1_scaffold-.+\.g.+\.t.+", str(clade)):
                        Co = clade
                        print ("ok")
                    else:
                        Genes_Cbp.append(clade)
                Gene1 = Genes_Cbp[0]
                Gene2 = Genes_Cbp[1]
                print(clade)
                if (tree.distance(Gene1, Cr) > tree.distance(Gene1, Co)) and (tree.distance(Gene2, Cr) < tree.distance(Gene2, Co)):
                    out90.append(Gene1.name+"\t"+"A"+"\n")
                    out90.append(Gene2.name+"\t"+"B"+"\n")
                    out70.append(Gene1.name+"\t"+"A"+"\n")
                    out70.append(Gene2.name+"\t"+"B"+"\n")
                    out60.append(Gene1.name+"\t"+"A"+"\n")
                    out60.append(Gene2.name+"\t"+"B"+"\n")
                if (tree.distance(Gene1, Cr) < tree.distance(Gene1, Co)) and (tree.distance(Gene2, Cr) > tree.distance(Gene2, Co)):
                    out90.append(Gene1.name+"\t"+"B"+"\n")
                    out90.append(Gene2.name+"\t"+"A"+"\n")
                    out70.append(Gene1.name+"\t"+"B"+"\n")
                    out70.append(Gene2.name+"\t"+"A"+"\n")
                    out60.append(Gene1.name+"\t"+"B"+"\n")
                    out60.append(Gene2.name+"\t"+"A"+"\n")
                if tree.distance(Gene1, Cr) == tree.distance(Gene1, Co):
                    out90.append(Gene1.name+"\t"+"U"+"\n")
                    out90.append(Gene2.name+"\t"+"U"+"\n")
                    out70.append(Gene1.name+"\t"+"U"+"\n")
                    out70.append(Gene2.name+"\t"+"U"+"\n")
                    out60.append(Gene1.name+"\t"+"U"+"\n")
                    out60.append(Gene2.name+"\t"+"U"+"\n")
            elif conmin >= 70:                      
                list_terminals = tree.get_terminals()
                Genes_Cbp = []
                for clade in  list_terminals:
                    print(clade)
                    if re.match("AT.+", str(clade)):
                        AT = clade
                    elif re.match("Carubv.+", str(clade)):
                        Cr = clade
                    elif re.match("CapOri_SW_1\.1_scaffold-.+\.g.+\.t.+", str(clade)):
                        Co = clade
                        print ("ok")
                    else:
                        Genes_Cbp.append(clade)
                Gene1 = Genes_Cbp[0]
                Gene2 = Genes_Cbp[1]
            
                if (tree.distance(Gene1, Cr) > tree.distance(Gene1, Co)) and (tree.distance(Gene2, Cr) < tree.distance(Gene2, Co)):
                    out70.append(Gene1.name+"\t"+"A"+"\n")
                    out70.append(Gene2.name+"\t"+"B"+"\n")
                    out60.append(Gene1.name+"\t"+"A"+"\n")
                    out60.append(Gene2.name+"\t"+"B"+"\n")
                if (tree.distance(Gene1, Cr) < tree.distance(Gene1, Co)) and (tree.distance(Gene2, Cr) > tree.distance(Gene2, Co)):
                    out70.append(Gene1.name+"\t"+"B"+"\n")
                    out70.append(Gene2.name+"\t"+"A"+"\n")
                    out60.append(Gene1.name+"\t"+"B"+"\n")
                    out60.append(Gene2.name+"\t"+"A"+"\n")
                if tree.distance(Gene1, Cr) == tree.distance(Gene1, Co):
                    out70.append(Gene1.name+"\t"+"U"+"\n")
                    out70.append(Gene2.name+"\t"+"U"+"\n")
                    out60.append(Gene1.name+"\t"+"U"+"\n")
                    out60.append(Gene2.name+"\t"+"U"+"\n")

            elif conmin >= 60:                      
                list_terminals = tree.get_terminals()
                Genes_Cbp = []
                for clade in  list_terminals:
                    print(clade)
                    if re.match("AT.+", str(clade)):
                        AT = clade
                    elif re.match("Carubv.+", str(clade)):
                        Cr = clade
                    elif re.match("CapOri_SW_1\.1_scaffold-.+\.g.+\.t.+", str(clade)):
                        Co = clade
                        print ("ok")
                    else:
                        Genes_Cbp.append(clade)
                Gene1 = Genes_Cbp[0]
                Gene2 = Genes_Cbp[1]
            
                if (tree.distance(Gene1, Cr) > tree.distance(Gene1, Co)) and (tree.distance(Gene2, Cr) < tree.distance(Gene2, Co)):
                    out60.append(Gene1.name+"\t"+"A"+"\n")
                    out60.append(Gene2.name+"\t"+"B"+"\n")
                if (tree.distance(Gene1, Cr) < tree.distance(Gene1, Co)) and (tree.distance(Gene2, Cr) > tree.distance(Gene2, Co)):
                    out60.append(Gene1.name+"\t"+"B"+"\n")
                    out60.append(Gene2.name+"\t"+"A"+"\n")
                if tree.distance(Gene1, Cr) == tree.distance(Gene1, Co):
                    out60.append(Gene1.name+"\t"+"U"+"\n")
                    out60.append(Gene2.name+"\t"+"U"+"\n")

            
            else:
                print("comin"+str(conmin))

for line in set(out90):
    out_genes90.write(line)        
for line in set(out70):
    out_genes70.write(line)
for line in set(out60):
    out_genes60.write(line) 
out_genes90.close()
out_genes70.close()
out_genes60.close()
