🚨 The backward translation circRNAs and  proteins are unpublished data and are not available for download at this time.<br>

The main sources of BawaCirc data come from three steps:
----
* ⭐ Step 1: Search for circRNAs and its corresponding ORFs.
* ⭐ Step 2: Look for translation evidence of backward translation proteins in mass spectrometry data.
* ⭐ Step 3: Searching for evidence of backward translation proteins being translated in Ribo-seq data.
  
## Requirement
✨ This software is suitable for all unix-like system with java (version 11.0.13) installed.<br>
Moreover, some already published softwares should be correctly installed in advance, and
make sure they had been add to your system environment variables. The thirteen softwares are:<br>
* SRA-tools (version 3.0.0)<br>
* Trimmomatic (version 0.38)<br>
* IDBA (version 1.1.2)<br>
* Gmap (version 2018-07-04)<br>
* Cufflinks (version 2.2.1)<br>
* CIRIT (provided 🎉)<br>
* trCirit (provided 🎉)<br>
* translate.pl (provided 🎉)<br>
* Dotnet (version 2.1.818)<br>
* MaxQuant (version 2.0.2.0)<br>
* Bowtie2 (version 2.2.5)<br>
* Samtools (version 1.3.1)<br>
* Seqkit (version 2.3.0)<br>
* Mosdepth (version 0.3.10)<br>

🤔 of course, for softwares mentioned above, other version is allowed. However, the pipeline operated
stably with the recommended version. <br>

## Directory Details
- **`IP/`**: Mass Spectrometry sample.
  - `README.md`: Documentation.
- **`Ribo-seq standard analysis/`**: The standard Ribo-seq data analysis pipeline.
  - `01.align_circBT.md`: Align reads to circRNA BT reference.
  - `02-riboWaltz_SRR6838651`: Generating plots with the riboWaltz package.
  - `NEBNext_adapter.fa`: NEBNext adapter sequences.
  - `README.md`: Documentation.
  - `orf_Forward_db.fa`: CircRNA forward translation ORFs.
  - `reverse.py`: Reverse the reads of the raw Ribo-seq data.
  - `scaffold.fa`: CircRNA backward translation ORFs.
  - `scaffold_waltz.gtf`: Annotaion file of scaffold.fa for ribowaltz analysis.
- **`doc/`**: Project documentation.
  - `Ribo-seq/`: The reference sequences of the species used in step3.
  - `png/`: The illustrations in step2.
  - `Step1.md`: Search for circRNAs and its corresponding ORFs.
  - `Step2.md`: Look for translation evidence of backward translation proteins in mass spectrometry data.
  - `Step3.md`: Searching for evidence of backward translation proteins being translated in Ribo-seq data.
- **`example_file/`**: Stores example files.
  - `README.md`: The download link for the example files.
- **`result/`**: Stores analysis results.
  - `README.md`: The download link for the result files.
- **`software/`**: Self-coded software download.
  - `Cirit/`: circRNA identification algorithm.
  - `trCirit/`: Identify BSJ (back-splice junctions) and predict ORFs (open reading frames).
  - `translate.pl`: Translate nucleotide sequences into amino acid sequences.
- **`LICENSE`**: under the Apache License 2.0.
- **`README.md`**: A summary of the project, including setup and usage instructions.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
