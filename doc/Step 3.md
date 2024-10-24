# Step 3: Searching for evidence of backward translation proteins being translated in Ribo-seq data.

1. Download SRA file

```bash
prefetch SRRXXX -X 50G
```

2. Split SRA file into single-end or paired-end FASTQ files

```bash
cd SRRXXX
fastq-dump -v --split-3 --gzip SRRXXX.sra*
```

3. Adapter removal using Trimmomatic

```bash
###single-end
java -jar ~/software/trimmomatic/trimmomatic-0.38.jar SE -threads 30 -phred33 \
SRRXXX.fastq.gz SRRXXX.clean.fastq \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50 TOPHRED33
###paired-end
java -jar ~/software/trimmomatic/trimmomatic-0.38.jar PE -threads 30 -phred33 \
SRRXXX_1.fastq.gz SRRXXX_2.fastq.gz SRRXXX_1.clean.fastq SRRXXX_1.unclean.fastq SRRXXX_2.clean.fastq SRRXXX_2.unclean.fastq \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50 TOPHRED33
```

4. Remove rRNA and other unwanted contaminants (such as linear RNA and FW ORFs). Then, place the sequences into the “remove.fa” file and build the index.

```bash
mkdir remove
cat rRNA.fa cds_from_genomic.fna forward_ORF.fa >remove.fa

bowtie2-build remove.fa remove

###single-end
bowtie2 --local -x ../remove/remove -U SRRXXX.clean.fastq -S null --un SRRXXX_remain.fq -p 80
###paired-end
bowtie2 --local -x ../remove/remove -1 SRRXXX_1.clean.fastq -2 SRRXXX_2.clean.fastq -S null --un-conc SRRXXX_remain.fq -p 80
```

5. Align with the BW ORF sequences (the BW ORF needs to be reversed back to the normal sequence direction).

```bash
seqkit seq -r Rev_backward_ORF.fa >backward_ORF.fa 

###build index
bowtie2-build backward_ORF.fa backward_ORF

mkdir result_backward
###single-end
bowtie2 --local -x ../backward/backward_ORF -U SRRXXX_remain.fq -S result_backward/SRRXXX_backward.sam --al result_backward/SRRXXX_backward.fq -p 80
###paired-end
bowtie2 --local -x ../backward/backward_ORF -1 SRRXXX_remain.1.fq -2 SRRXXX_remain.2.fq -S result_backward/SRRXXX_backward.sam --al-conc result_backward/SRRXXX_backward.fq -p 80
```

6. Convert SAM files to BAM files

```bash
cd result_backward
samtools view -S SRRXXX_backward.sam -b >SRRXXX_backward.bam
###sorted###
samtools sort SRRXXX_backward.bam -o SRRXXX_backward_sorted.bam
### build index###
samtools index SRRXXX_backward_sorted.bam
```

7. Use bamdst to analyze BAM files

```bash
cd ../../backward
samtools faidx backward_ORF.fa
cat backward_ORF.fa.fai | awk '{print $1"\t1\t"$2}' > backward.bed

cd ../SRRXXX/result_backward
mkdir bam_result
bamdst -p ../../backward/backward.bed SRRXXX_backward_sorted.bam -o bam_result
```

