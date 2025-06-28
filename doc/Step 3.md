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
ILLUMINACLIP:TruSeq3-SE.fa:2:30:10:2:True LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:25 TOPHRED33
```

4. Remove rRNAs (download from NCBI) and other unwanted contaminants (mRNAs (download from NCBI), ncRNAs(download from rnacentral) and circRNA forward ORFs). Then, place the sequences into the “remove.fa” file and build the index. (BawaCirc/doc/Ribo-seq/*/remove.fa)

```bash
bowtie-build remove.fa remove
bowtie -p 30 -v 1 remove test_clean.fastq --un test_unaligned.fq > /dev/null
```

5. Alignment of the 25nt sequences flanking the BSJ of circRNA corresponding to the backward ORFs spanning the BSJ (A total of 50nt). (BawaCirc/doc/Ribo-seq/*/Backward_BSJ.fa)

```bash
bowtie-build Backward_BSJ.fa Backward_BSJ
bowtie -p 30 -v 3 Backward_BSJ test_unaligned.fq -S test_backward_BSJ.sam
```

6. Convert SAM files to BAM files

```bash
samtools view -S test_backward_BSJ.sam -b >test_backward_BSJ.bam
###sorted###
samtools sort test_backward_BSJ.bam -o test_backward_BSJ_sorted.bam
### build index###
samtools index test_backward_BSJ_sorted.bam
```

7. Use mosdepth to analyze BAM files

```bash
samtools faidx backward_ORF.fa
cat backward_ORF.fa.fai | awk '{print $1"\t1\t"$2}' > backward.bed

mosdepth --by backward.bed test test_backward_sorted.bam --thresholds 1,2,5,10
```

