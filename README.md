# ukbb_pvcf2pgen
UKBB pVCF to plink pgen conversion

The code will apply a genotype-level filter on GQ and DP (calculated from LAD) on the pVCF files, apply a genotype missingness filter, filter on the `FILTER` column, and output as a plink pgen/psam/pvar

For the X-chromosome, the code will halve the DP threshold for males automatically

## Building applet

To build the applet use `dxpy`

```
git clone git@github.com:chundruv/ukbb_pvcf2pgen.git
cd ukbb_pvcf2pgen
dx build -f -d ${PROJECT_ID}:${PATH}
```

## Using applet

Parameters:
 - vcf_list - A list of vcf chunks to do within one job (best to split each chromosome into a few hundred to convert within one job)
 - processes - maximum number of parallel conversions to do within one job
 - mem - Maximum memory to assign for each plink job
 - sex_file - for chrX conversion you will need to provide a file with the header "#IID SEX"
 - PAR - True or False if the list contains PAR region chunks (Separate PAR and Non-PAR chunks to different lists)
 - outdir - Where to output the pgen files
 - mingq - Minimum GQ to keep
 - mindp - Minimum DP to keep
 - maxmiss - Genotype missingness filter

Once all chunks are converted for a chromosome download them to a job and use the plink flag `--pmerge-list` to merge all pgens
