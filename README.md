The main sources of [BawaCirc](http://www.bio-add.org/BawaCirc) data come from three steps:
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
* Cirit (provided 🎉)<br>
* trCirit (provided 🎉)<br>
* translate.pl (provided 🎉)<br>
* Dotnet (version 2.1.818)<br>
* MaxQuant (version 2.0.2.0)<br>
* Bowtie2 (version 2.2.5)<br>
* Samtools (version 1.3.1)<br>
* Seqkit (version 2.3.0)<br>
* Bamdst (version 1.0.9)<br>

🤔 of course, for softwares mentioned above, other version is allowed. However, the pipeline operated
stably with the recommended version. <br>
