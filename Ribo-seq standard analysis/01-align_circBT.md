## 1.  Build index of different reference

- remove reads mapping to mRNA cds region (not transcript ref)

```bash
# build index of mRNA/rRNA/lncRNA
# reads aligned to this reference needed to be removed. 
[ ! -d "remove_index/" ] && mkdir -p remove_index/
bowtie-build merged_cds_rRNA_lncRNA.fa remove_index/remove
```

```bash
# circRNA forward translation reference
mkdir -p forward_orf_index/
bowtie-build orf_Forward_db.fa forward_orf_index/forward
```

```bash
# circRNA backward translation reference
!mkdir -p scaffold_index
!bowtie-build scaffolf.fa scaffolod_index/scaffold
```

## **2. Remove reads which align to mRNA/rRNA/lncRNA reference and align reads to circRNA BT reference**

```bash
# pre-processing
java -jar trimmomatic-0.39.jar SE -threads 30 -phred33 SRR6838651.fastq.gz SRR6838651_clean.fastq ILLUMINACLIP:NEBNext_adapter.fa:2:30:10:2:True LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:25 TOPHRED33
```

```bash
# QC 
fastqc SRR6838651_clean.fastq
```

```bash
# remove reads which align to unwanted region - mRNA/rRNA/lncRNA
bowtie -p80 -v 3 -x remove_index/remove ref_mRNA/SRR6838651_clean.fastq --un ref_circBT/SRR6838651_unalign_rna.fq > /dev/null
```

```bash
# remove reads which align to unwanted region - circRNA FT ORF
bowtie -p80 -v 3 -x forward_orf_index/forward ref_circBT/SRR6838651_unalign_rna.fq --un ref_circBT/SRR6838651_unaligned_circforward.fq > /dev/null
```

```bash
# reverse the reads
python reverse.py ref_circBT/SRR6838651_unaligned_circforward.fq ref_circBT/SRR6838651_reversed.fq
```

```bash
# align reads to circRNA BT ref
bowtie -p 80 -v 3 -x scaffold_index/scaffold ref_circBT/SRR6838651_reversed.fq -S ref_circBT/SRR6838651.sam
```

```bash
samtools view -bS ref_circBT/SRR6838651.sam -o ref_circBT/SRR6838651.bam
samtools sort ref_circBT/SRR6838651.bam -o ref_circBT/SRR6838651.sort.bam
samtools index ref_circBT/SRR6838651.sort.bam
```
