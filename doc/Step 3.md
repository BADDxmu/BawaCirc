# Step 3: Searching for evidence of backward translation proteins being translated in Ribo-seq data.

1. Download SRA file

```bash
prefetch test -X 50G
```

2. Split SRA file into single-end or paired-end FASTQ files

```bash
fastq-dump -v --split-3 --gzip test.sra*
```

3. Adapter removal using Trimmomatic

```bash
###single-end
java -jar trimmomatic-0.38.jar SE -threads 30 -phred33 \
test.fastq.gz test.clean.fastq \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50 TOPHRED33
```

4. Remove rRNA and other unwanted contaminants (such as linear RNA and FW-ORFs). Then, place the sequences into the “remove.fa” file and build the index.

```bash
mkdir remove
cat rRNA.fa cds_from_genomic.fna forward_ORF.fa >remove.fa

bowtie2-build remove.fa remove

###single-end
bowtie2 --local -x remove -U test.clean.fastq -S null --un test_remain.fq -p 80
```

5. Align with the BW ORF sequences (the BW ORF needs to be reversed back to the normal sequence direction).

```bash
seqkit seq -r Rev_backward_ORF.fa >backward_ORF.fa 

###build index
bowtie2-build backward_ORF.fa backward_ORF

mkdir result_backward
###single-end
bowtie2 --local -x backward_ORF -U test_remain.fq -S test_backward.sam --al test_backward.fq -p 80
```

6. Convert SAM files to BAM files

```bash
cd result_backward
samtools view -S test_backward.sam -b >test_backward.bam
###sorted###
samtools sort test_backward.bam -o test_backward_sorted.bam
### build index###
samtools index test_backward_sorted.bam
```

7. Use mosdepth to analyze BAM files

```bash
samtools faidx backward_ORF.fa
cat backward_ORF.fa.fai | awk '{print $1"\t1\t"$2}' > backward.bed

mosdepth --by backward.bed test test_backward_sorted.bam --thresholds 1,2,5,10
```

