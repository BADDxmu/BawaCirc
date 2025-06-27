rm(list = ls())
setwd("test")

library(riboWaltz)

# 1. Acquirinng input files ----
## input bam files and output data table of each transcripts
my_anno <- create_annotation(gtfpath = "../scaffold_waltz.gtf")

name_bam <- c("SRR6838651") # 重命名
names(name_bam) <- c("SRR6838651.sort") # 原来名称
read_list <- bamtolist(bamfolder = ".", 
                       annotation = my_anno,
                       name =name_bam)

example_length_dist <- rlength_distr(read_list, sample = "SRR6838651", 
                                     colour = "#333f50")
example_length_dist[["plot_SRR6838651"]]


# 2. Filtering options ----
## Fun: duplicates_filter and length_filter
filtered_list <- length_filter(data = read_list,
                               length_filter_mode = "custom", #periodicity/custom
                               length_range = 25:34)
filtered_list[["SRR6838651"]]

filter_length_dist <- rlength_distr(filtered_list, sample = "SRR6838651", 
                                    colour = "#333f50")
filter_length_dist[["plot_SRR6838651"]]
ggsave("output/01-reads_length_distr.png", width = 5, height = 3.5,
       plot = last_plot())

# 3. Annotation data table ----
## data table of as least five columns. trascripts length, length of 5` UTR, CDS and 3` UTR
## it can be provided by user or generated starting from GTF/GTT or TxDb object 
## derived from the same release of the seqs used in the alignment step.
psite_offset <- psite(filtered_list, flanking = 6, extremity = "5end", 
                      plot = TRUE, plot_dir = ".")
reads_psite_list <- psite_info(filtered_list, psite_offset)


ends_heatmap <- rends_heat(filtered_list, my_anno,
                           sample = "SRR6838651", cl = 85,
                           utr5l = 25, cdsl = 40, utr3l = 25,
                           colour = "#333f50")
ends_heatmap[["plot_SRR6838651"]]

# 4. P-site offset ----
## Fun: psite and psite_info
psite_per_region <- region_psite(reads_psite_list, my_anno,
                                 sample = "SRR6838651",
                                 plot_style = "dodge",
                                 colour = c("#333f50", "gray70", "#39827c"))

psite_per_region[["plot"]]
ggsave("output/02-psite_sperate.png", width = 10, height = 7,
       plot = last_plot())

# 5. Trinucleotide periodicity ----
example_frames_stratified  <- frame_psite_length(reads_psite_list, my_anno,
                                                 sample = "SRR6838651",
                                                 multisamples = "average",
                                                 length_range = 25:34,
                                                 plot_style = "facet",
                                                 region = "all", # all | cds | 5utr | 3 utr
                                                 cl = 85, colour = "#333f50")
example_frames_stratified[["plot_SRR6838651"]]
ggsave("output/03-periodicity.png", width = 10, height = 7,
       plot = last_plot())

## 6. metaplots ----
metaprofile <- metaprofile_psite(reads_psite_list, my_anno,
                                 sample = "SRR6838651",
                                 utr5l = 20, cdsl = 40, utr3l = 20,
                                 colour = "#39827c")
metaprofile[["plot_SRR6838651"]]
ggsave("output/04-metaprofile.png", width = 10, height = 7,
       plot = last_plot())

