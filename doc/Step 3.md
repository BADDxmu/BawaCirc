# Step 3: Searching for evidence of backward translation proteins being translated in Ribo-seq data.

## 1. Download SRA files

```bash
prefetch test -X 50G
```

## 2. Convert each SRA file to a single-end FASTQ file

```bash
fasterq-dump test.sra --split-3 -e 60
```

Only single-end Ribo-seq reads were used in the following analysis.

## 3. Remove adapters and retain ribosome-footprint-length reads

The adapter sequence was selected according to the library construction protocol of each project and saved in `adapter.fa`.

```bash
java -jar trimmomatic-0.39.jar SE -threads 60 -phred33 \
test.fastq.gz test.trimmed.fastq.gz \
ILLUMINACLIP:adapter.fa:2:30:10

seqkit seq -m 25 -M 35 \
test.trimmed.fastq.gz \
-o test.footprint_25_35nt.fastq
```

For libraries generated using RNA polyadenylation, terminal poly(A) sequences were removed before length selection. Project-specific 3-prime adapters and terminal poly(G) sequences were additionally removed when required by the original library protocol.

## 4. Prepare the contaminant, Forward ORF, and Backward BSJ references

The `remove.fa` reference contained deduplicated rRNA, transcript, and ncRNA sequences. Forward circRNA ORFs were not included in `remove.fa`; they were combined and deduplicated separately in `Forward_ORF.fa`. Each sequence in `Backward_BSJ.fa` was 50 nt long, consisting of 25 nt upstream and 25 nt downstream of the BSJ of a backward ORF-containing circRNA.

```bash
cat rRNA.fa transcript.fa ncRNA.fa | \
seqkit rmdup -s -o remove.fa

cat Forward_ORF_source/*.fa | \
seqkit rmdup -s -o Forward_ORF.fa

bowtie-build remove.fa remove
bowtie-build Forward_ORF.fa Forward_ORF
bowtie-build Backward_BSJ.fa Backward_BSJ
```

## 5. Remove reads derived from rRNAs, mRNAs, and ncRNAs

The removal step was intended to filter contaminants as completely as possible. Therefore, `-m 1`, `--best`, and `--strata` were not used.

```bash
bowtie -S -p 60 -v 1 \
--un test.remove_unaligned.fastq \
remove test.footprint_25_35nt.fastq \
test.remove.sam
```

## 6. Remove reads matching Forward circRNA ORFs

Reads that could be explained by conventional Forward ORFs were removed before searching for evidence of backward translation. As in the contaminant-removal step, multimapping reads were removed and no unique-mapping restriction was applied.

```bash
bowtie -S -p 60 -v 1 \
--un test.forward_unaligned.fastq \
Forward_ORF test.remove_unaligned.fastq \
test.Forward_ORF.sam
```

## 7. Align the remaining reads to the Backward BSJ reference

The remaining reads were aligned to the 50-nt Backward BSJ reference with no more than one mismatch. All alignments in the best stratum were reported because identical or shared BSJ sequences may correspond to multiple circRNA database IDs. The `-m 1` option was not used.

```bash
bowtie -S -p 60 -v 1 -a --best --strata \
Backward_BSJ test.forward_unaligned.fastq \
test.backward_BSJ.sam
```

## 8. Retain genuine BSJ-spanning reads using an anchor filter

The BSJ was located between positions 25 and 26 of each 50-nt reference. A mapped read was retained only when it crossed this junction and provided an anchor of at least 3 nt on both sides.

```bash
python3 scripts/filter_bsj_anchor.py \
-i test.backward_BSJ.sam \
-o test.backward_BSJ.anchor.sam \
--summary test.backward_BSJ.anchor.summary.txt \
--bsj_pos 25 --min_anchor 3
```

The anchor-filter summary reports `Total_SAM_records`, `Mapped_records`, and `BSJ_anchor_reads`.

## 9. Count supported circRNAs and define high-confidence evidence

Anchor-filtered alignments were counted for each Backward BSJ reference. A backward ORF-containing circRNA was considered high confidence in a sample when it was supported by at least two BSJ-spanning reads.

```bash
samtools view -F 4 test.backward_BSJ.anchor.sam | \
cut -f 3 | sort | uniq -c | \
awk 'BEGIN{OFS="\t"; print "BSJ_ID","BSJ_anchor_reads"} \
{print $2,$1}' \
> test.backward_BSJ.read_count.tsv

awk 'BEGIN{FS=OFS="\t"} NR==1 || $2>=2' \
test.backward_BSJ.read_count.tsv \
> test.backward_BSJ.high_confidence.tsv
```

When the total number of BSJ-spanning reads was summarized across circRNA IDs, each read name was counted only once within each sample, even if the read aligned to multiple circRNA IDs.

## 10. Convert the Backward BSJ alignments to sorted and indexed BAM files

```bash
samtools view -@ 4 -bS test.backward_BSJ.sam | \
samtools sort -@ 4 -o test.backward_BSJ.sorted.bam

samtools index test.backward_BSJ.sorted.bam
```

The sorted BAM file can be inspected in IGV together with the 50-nt `Backward_BSJ.fa` reference. The anchor-filtered SAM file and per-circRNA count tables should be used to determine BSJ-spanning support.

## 11. Review the results

For every sample, read numbers were recorded for the following steps: Raw, Trimmed, Footprint_25_35nt, After_remove_rRNA_mRNA_ncRNA, After_remove_Forward_ORF, Backward_BSJ_mapped, and Backward_BSJ_anchor. Retention relative to the preceding step and to the raw reads was reported in `test.summary.tsv`.

The main result files were:

```text
test.summary.tsv
test.backward_BSJ.read_count.tsv
test.backward_BSJ.high_confidence.tsv
test.backward_BSJ.sorted.bam
test.backward_BSJ.sorted.bam.bai
```
