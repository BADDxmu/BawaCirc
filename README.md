The main sources of [BawaCirc](http://www.bio-add.org/BawaCirc) data come from three steps:
----
* Step1: Search for circRNA and its corresponding ORFs.
* Step2: Look for translation evidence of backward translation proteins in mass spectrometry data.
* Step3: Searching for evidence of backward translation proteins being translated in Ribo-seq data.
## Requirement
This software is suitable for all unix-like system with java (version 11.0.13) installed.<br>
Moreover, some already published softwares should be correctly installed in advance, and
make sure they had been add to your system environment variables. The thirteen softwares are:<br>
(1) SRA-tools (version 3.0.0)<br>
(2) Trimmomatic (version 0.38)<br>
(3) IDBA (version 1.1.2)<br>
(4) Gmap (version 2018-07-04)<br>
(5) Cufflinks (version 2.2.1)<br>
(6) Cirit (provided)<br>
(7) trCirit (provided)<br>
(8) Dotnet (version 2.1.818)<br>
(9) MaxQuant (version 2.0.2.0)<br>
(10) Bowtie2 (version 2.2.5)<br>
(11) Samtools (version 1.3.1)<br>
(12) Seqkit (version 2.3.0)<br>
(13) Bamdst (version 1.0.9)<br>
of course, for softwares mentioned above, other version is allowed. However, the pipeline operated
stably with the recommended version. <br>
