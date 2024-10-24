# CircRNA detection

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
java -jar ~/software/trimmomatic/trimmomatic-0.38.jar PE -threads 30 -phred33 \
SRRXXX_2.fastq.gz SRRXXX_1.clean.fastq SRRXXX_1.unclean.fastq SRRXXX_2.clean.fastq SRRXXX_2.unclean.fastq \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50 TOPHRED33
```

4. Assembly with IDBA (k-mer size based on the length of the SRRXXX.merge.fa file)

```bash
#### 1. Merge ####
fq2fa --merge --filter SRRXXX_1.clean.fastq SRRXXX_2.clean.fastq SRRXXX.merge.fa

#### 2. De novo assembly ####
idba_tran -r SRRXXX.merge.fa --mink 125 --maxk 150 --step 5 --num_threads 80
```

5. Select circRNA using Cirit (e.g. 145)

```bash
java -jar ~/software/cirit/Cirit-1.0.jar -i out/transcript-145.fa -o circ.fa
```

6. Annotate with trCirit-BSJ using Gmap (build index)

```bash
# Build the index using Gmap
gmap_build -d chm13 chm13.fasta (latest version)
java -jar ~/software/trcirit/trCirit_BSJ-1.0.1-SNAPSHOT.jar -i circ.fa -i2 ~/genome/chm13.bed -i3 chm13

#### Use trCirit-ORF to find ORFs ####
java -jar ~/software/trcirit/trCirit_ORF-1.0.1.jar -i circ_anno.gtf -g ~/genome/chm13.fasta
```

7. Replace sequence names in out_ORF

```bash
cd out_ORF
sed -i "s/transcript-145/SRRXXX_BN/g" trCiritOrf_3seqR.fa
sed -i "s/transcript-145/SRRXXX_FN/g" trCiritOrf_3seqS.fa
sed -i "s/transcript-145/SRRXXX_FB/g" trCiritOrfBSJ_3seqS.fa
sed -i "s/transcript-145/SRRXXX_BB/g" trCiritOrfBSJ_3seqR.fa

cat *.fa > ../SRRXXX_ORF.fa
```

8. Translate ORFs into protein sequences

```bash
perl ~/code/translate.pl SRRXXX_ORF.fa SRRXXX_Pep.fa
```
