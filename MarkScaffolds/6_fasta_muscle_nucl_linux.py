Cbp_Cbp_Co_Cr_At = open("../fives/Cbp_vs_Cbp_vs_Cr_vs_Co_vs_Ath.dedup.fives", 'r')
from Bio import SeqIO
import os


i = 1
for line in Cbp_Cbp_Co_Cr_At:
    file = open("fasta/{}.fasta".format(i), 'w')
    line = line.strip()
    line = line.split("\t")
    cbp1 = line[0]
    cbp2 = line[1]
    co = line[3]
    cr = line[2]
    at = line[4]
    CBP = open("../source_seqs_and_anot/Capsella_bursa_v3.cut.CDS.fa", 'r')
    for record in SeqIO.parse(CBP, "fasta"):
        if cbp1 == record.id:
            SeqIO.write(record, file, "fasta")
        if cbp2 == record.id:
            SeqIO.write(record, file, "fasta")
    CO = open("../source_seqs_and_anot/CO3.codingseq", 'r')
    for record in SeqIO.parse(CO, "fasta"):
        if co == record.id:
            SeqIO.write(record, file, "fasta")
    CR = open("../source_seqs_and_anot/Crubella_good.fasta", 'r')
    for record in SeqIO.parse(CR, "fasta"):
        if cr == record.id:
            SeqIO.write(record, file, "fasta")
    AT = open("../source_seqs_and_anot/Athaliana_167_TAIR10.cds_primaryTranscriptOnly.fa", 'r')
    for record in SeqIO.parse(AT, "fasta"):
        if at == record.id:
            SeqIO.write(record, file, "fasta") 
    file.close()

    file = "fasta/{}.fasta".format(i)
    file_aln = "align/{}_aln.fasta".format(i)
    path_to_trees = "/home/artem/Capsella/Analyze_new3/mark_scaffs/tree/"
    file_tree = "{}".format(i)
    os.system("/home/artem/soft/muscle3.8.31_i86linux64 -in {} -out {}".format(file, file_aln))
    os.system("/home/artem/soft/RaXML/standard-RAxML/raxmlHPC -f a -T 2 -x 50 -N 100 -n {} -p 199 -m GTRGAMMA -w {} -s {}".format(file_tree, path_to_trees, file_aln))

    i=i+1
