import nwalign,sys
from Bio.SeqRecord import SeqRecord
from Bio.Alphabet import IUPAC

from Bio import SeqIO,Seq

fileNameA = sys.argv[1]
fileNameB = sys.argv[2]
fileNameToAlign = sys.argv[3]
fileNameOut = sys.argv[4]

seqA = ""
seqB = ""

idA = ""
idB = ""

aSeqs = dict();
bSeqs = dict();


handleWrite = open(fileNameOut, "w")

handle = open(fileNameA, "rU")
for record in SeqIO.parse(handle, "fasta") :
    idA = record.id
    seqA = str(record.seq)
    aSeqs[idA] = seqA
handle.close()


handle = open(fileNameB, "rU")
for record in SeqIO.parse(handle, "fasta") :
    idB = record.id
    seqB = str(record.seq)
    bSeqs[idB] = seqB
handle.close()


handle = open(fileNameToAlign, "rU")
for line in handle:
    line = line.rstrip()
    genesList = line.split("\t")
    geneA = genesList[0]
    geneB = genesList[1]
    
    seqTxtA = aSeqs[geneA].upper()
    seqTxtB = bSeqs[geneB].upper()
    alignment = nwalign.global_align(seqTxtA, seqTxtB, matrix='NUC.4.4',gap_open=-11,gap_extend=-1)
    
    lenOfSeqs = len(alignment[0])
    matched = 0
    
    for i in range(len(alignment[0])):
        currLetterA = alignment[0][i]
        currLetterB = alignment[1][i]
        print currLetterA
        print currLetterB
        
        if currLetterA == currLetterB:
                matched = matched + 1;
                
    print str(matched)
    print str(lenOfSeqs)
    ident = float(float(matched)/float(lenOfSeqs))
    handleWrite.write(str(geneA)+"\t"+str(geneB)+"\t"+str(ident)+"\n")

handle.close()
handleWrite.close()

