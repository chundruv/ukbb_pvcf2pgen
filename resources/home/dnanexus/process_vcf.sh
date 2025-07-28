#!/bin/bash

echo "Processing $1"
chrom=`echo $1 | sed 's/_/\t/g' | cut -f2 | sed 's/c/chr/g'`

dx find data --project "${DX_PROJECT_CONTEXT_ID}" --folder "${outdir}/$chrom/" > ${1::-7}.results_files_present

if grep -Fq ${1::-7}.pgen ${1::-7}.results_files_present;
then
    echo "Done ${1::-7}.pgen"
else

dx download "${DX_PROJECT_CONTEXT_ID}:/Bulk/DRAGEN WGS/DRAGEN population level WGS variants, pVCF format [500k release]/${chrom}/${1}"
./plink2_ukbb_vcftopgen --vcf ${1} --memory ${mem} --geno ${maxmiss} --vcf-min-gq ${mingq} --vcf-min-dp ${mindp} --var-filter --set-all-var-ids "@:#:\$r:\$a" --new-id-max-allele-len 1000 --import-max-alleles 255 --make-pgen multiallelics=- --out ${1::-7}
dx upload ${1::-7}.p* --path "${DX_PROJECT_CONTEXT_ID}:${outdir}/${chrom}/"
rm ${1}
rm ${1::-7}.p*

fi
