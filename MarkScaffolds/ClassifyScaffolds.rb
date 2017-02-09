scaffGeneCountsFile = ARGV[0]
outAFile = ARGV[1]
outBFile = ARGV[2]




fileOutADesc = open(outAFile,"w")
fileOutBDesc = open(outBFile,"w")



fileDesc = open(scaffGeneCountsFile,"r")


while line = fileDesc.gets
  line.chomp!
  
  arrLine = line.split(/\t/)
  
  scaffNam = arrLine[0]
  allGenesNum = arrLine[1].to_f
  aGenesNum = arrLine[2].to_f
  bGenesNum = arrLine[3].to_f
  
  aPerc = (aGenesNum/allGenesNum)*100
  bPerc = (bGenesNum/allGenesNum)*100
  
  if aGenesNum > bGenesNum
    fileOutADesc.puts("#{scaffNam}\t#{aPerc}\t#{bPerc}\n")
  else
    if bGenesNum > aGenesNum
      fileOutBDesc.puts("#{scaffNam}\t#{aPerc}\t#{bPerc}\n")
    end
  end
end




