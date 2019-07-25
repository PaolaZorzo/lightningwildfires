#OBSERVAR CAMADA MASCARA E ANO
#ATENCAO PARA ANO BISSEXTO
library(Matrix)
library(maps)
library(mapdata)
library(maptools)
library(sp)
library(raster)
library(RgoogleMaps)
library(spatial)
library(eyelinker)
library(remotes)
library(rgdax)
library(gridBase)
library(asciiSetupReader)
library(rgdal)
library(adehabitatHR)
library(adehabitatMA)
library(SDMTools)
library(ncdf4)
print("ESTE ALGORITMO CALCULA A DENSIDADE DE REL?MPAGOS POR GRID POR DIA")
#declarando diret?rio principal
setwd("F:/RA")
#confere o diret?rio
getwd()
#lista os arquivos do diret?rio
dir()
#i loop do dia
i=1
#dimensão do vetor do total de relãmpagos por dia na área de estudo
#k<-(1:365)
#fila com nome dos arquivos para salvar em NetCDF
#nc<-read.table("2016_exp_nc.txt", header = TRUE)
#fila com nome dos arquivos para salvar em GeoTIFF
tif<-read.table("2016_exp_tif.txt", header = TRUE)
while (i<=366){
  #controle de loop
  print(i)
  #diretório da fila
  setwd("F:/RA")
  #X lê a tabela que tem o nome dos arquivos a serem abertos
  x<-read.table("2016.txt", header=TRUE)
  #diretório dos dados
  setwd("F:/RA/raios_2016")
  #ra abre os arquivos de ral?mpagos por linha da tabela
  ra<-read.table(paste(x[i,1]),header=TRUE, sep=',', dec='.')
  #j recebe a demins?o (linhas [1] x colunas [2]) do aquivo de rel?mpagos
  j<-dim(ra)
  #k ? o total de rel?mpagos
  #k[i]<-j[1]
  # Criando o SpatialPointsDataFrame a partir da tabela.
  pontos_ra<-SpatialPointsDataFrame(ra[,9:8],ra)
  #Plot dos rel?mpagos
  #plot(pontos_ra)
  print("COMANDOS PARA CAMADA MASCARA")
  setwd("F:/RA/MASCARA")
  #definindo o arquivo raster(raster)
  # NULL=-9999 para declarar valores nulos
  #diss_sm n?o possi contorno, portanto n?o tem "mascara"
  r<-raster("MASC.tif")
  #convertendo para asc(SDMTools)
  a<-asc.from.raster(r)
  # Converte um objeto da classe asc em um objeto da classe SpatialGridDataFrame(adehabitatMA)
  grd<-asc2spixdf(a) 
  #testar funcionamento
  class(grd)
  #conferindo atributos
  attr(grd,"package")
  #numeros de pontos em cada pixel do raster(rgdal)
  cp<-count.points(pontos_ra,grd)
  #cp
  #diretótio para salvar
  setwd("F:/RA/RA_dia")
  #image(cp)
  #tranformar SpatialPixelsDataFrame para raster
  ex<-raster(cp)
  #exportar raster para .tif
  writeRaster(ex,paste(tif[i,1]),"GTiff",overwrite=TRUE)
  #exportar raster para .nc
  #writeRaster(ex,paste(nc[i,1]),"CDF",overwrite=TRUE)
  #loop dias
  i=i+1
}
#exportando vetor do total de relãmpagos por dia na área de estudo
#write.table(k[1:365],"RA_dia_2016.txt")
print("FIM DO PROGRAMA")