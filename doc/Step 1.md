# Step 1: Search for circRNA and its corresponding ORFs

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
java -jar trimmomatic-0.38.jar PE -threads 30 -phred33 \
test_1.fastq.gz test_2.fastq.gz test_1.clean.fastq test_1.unclean.fastq test_2.clean.fastq test_2.unclean.fastq \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50 TOPHRED33
```

4. Assembly with IDBA (k-mer size based on the length of the test.merge.fa file)

```bash
#### 1. Merge ####
fq2fa --merge --filter test_1.clean.fastq test_2.clean.fastq test.merge.fa

#### 2. De novo assembly ####
idba_tran -r test.merge.fa --mink 125 --maxk 150 --step 5 --num_threads 80
```

5. Select circRNA using Cirit (e.g. 145)

```bash
java -jar Cirit-1.0.jar -i out/transcript-145.fa -o circ.fa
```

6. Annotate with trCirit-BSJ using Gmap (build index)

```bash
# Build the index using Gmap
gmap_build -d chm13 chm13.fasta (latest version)
java -jar trCirit_BSJ-1.0.1-SNAPSHOT.jar -i circ.fa -i2 chm13.bed -i3 chm13

#### Use trCirit-ORF to find ORFs ####
java -jar trCirit_ORF-1.0.1.jar -i circ_anno.gtf -g chm13.fasta
```

7. Replace sequence names in out_ORF

```bash
cat out_ORF/*.fa > test_ORF.fa
```

8. Translate ORFs into protein sequences

```bash
perl translate.pl test_ORF.fa test_Pep.fa
```
