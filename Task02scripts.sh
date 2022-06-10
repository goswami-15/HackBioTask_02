#!/usr/bin/bash
#Count the number of sequences in DNA.fa
grep -c ">" DNA.fa 
#total A, T, G & C counts 
grep -v '>' DNA.fa| grep -E  -o  "G|A|T|C|N" | wc -l
#Set up a conda environment
wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh
conda create -n mworkshop
conda activate mworkshop
# Installation of tools 
conda install -c bioconda fastqc
conda install -c bioconda fastp
pip install cutadapt
conda install -c bioconda multiqc
conda install -c bioconda spades
#Downloads some sample datasets 
wget wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Alsen_R1.fastq.gz?raw=true -O Alsen_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Alsen_R2.fastq.gz?raw=true -O Alsen_R2.fastq.gz
#Implement the fastqc software on the downloaded files
cd HackBioWorkshop/Task_02/RawReads/
mkdir -p QC_Reports
fastqc *_R1.fastq.gz *_R2.fastq.gz -o QC_Reports/
#Implement the mutiqc software on the downloaded files
mkdir -p Output_Multiqc
multiqc QC_Reports -o Output_Multiqc/
##Implement the fastp software on the downloaded files
mkdir fastp_output
fastp -i A_R1.fastq.gz -o fastp_output/Alsen_R1.fastq.gz
fastp -i A_R2.fastq.gz -o fastp_output/Alsen_R2.fastq.gz
#Implement the cutadapt software on the downloaded files
cutadapt -a TGGAATTCTCGG -A GATCGTCGGACT  -o Alsen_R1.fastq.gz  -p Alsen_R2.fastq.gz  A_R1.fastq.gz  A_R2.fastq.gz
#Implement the spades software on the downloaded files
mkdir spades_reports
spades.py -1 Alsen_R1.fastq.gz -2 Alsen_R2.fastq.gz --careful --cov-cutoff auto -o spades_report
