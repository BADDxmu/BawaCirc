# 1. Build index of different reference
- remove reads mapping to mRNA cds region (not transcript ref)

# build index of mRNA/rRNA/lncRNA
# reads aligned to this reference needed to be removed. 
![ ! -d "remove_index/" ] && mkdir -p remove_index/
!bowtie-build merged_cds_rRNA_lncRNA.fa remove_index/remove
