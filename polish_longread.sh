#Set input and parameters
round=2
threads=19
read=../../raw_data/all_chrom.fastq
read_type=ont #{clr,hifi,ont}, clr=PacBio continuous long read, hifi=PacBio highly accurate long reads, ont=NanoPore 1D reads
mapping_option=(["clr"]="map-pb" ["hifi"]="asm20" ["ont"]="map-ont")
input=../nextdenovo_assmebly/01_rundir/03.ctg_graph/nd.asm.fasta 

for ((i=1; i<=${round};i++)); do
    minimap2 -ax ${mapping_option[$read_type]} -t ${threads} ${input} ${read}|samtools sort - -m 2g --threads ${threads} -o lgs.sort.bam;
    samtools index lgs.sort.bam;
    ls `pwd`/lgs.sort.bam > lgs.sort.bam.fofn;
    python ../NextPolish/lib/nextpolish2.py -g ${input} -l lgs.sort.bam.fofn -r ${read_type} -p ${threads} -sp -o genome.nextpolish.fa;
    if ((i!=${round}));then
        mv genome.nextpolish.fa genome.nextpolishtmp.fa;
        input=genome.nextpolishtmp.fa;
    fi;
done;
# Finally polished genome file: genome.nextpolish.fa
