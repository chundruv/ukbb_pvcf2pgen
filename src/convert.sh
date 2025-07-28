#!/bin/bash

main() {
    

    set -e
    unset DX_WORKSPACE_ID
    dx cd $DX_PROJECT_CONTEXT_ID:

    echo "VCF list filename: '$vcf_list'"

    chmod 777 *
    dx download "$vcf_list" -o vcf_list
    if [[ ! -z "${sex_file}" ]]; then
    dx download "$sex_file" -o sex_file.txt
    fi

    chrom=`head -n1 vcf_list | sed 's/_/\t/g' | cut -f2 | sed 's/c/chr/g'`

    for file in $( dx find data --project "${DX_PROJECT_CONTEXT_ID}" --folder "${outdir}/$chrom/" --state=open --brief );do
        dx rm ${file}
    done

    readarray -t arr < vcf_list
    if [[ "${chrom}" != "chrX" ]]; then
        printf '%s\0' "${arr[@]}" | xargs -0 -n1 -P${processes} sh -c 'bash process_vcf.sh "$1" $DX_PROJECT_CONTEXT_ID $mem $outdir $mingq $mindp $maxmiss' _
    elif [[ "${PAR}" == "false" ]]; then
        if [[ -z "${sex_file}" ]]; then
	    echo "Need sex file"
	    exit 1
	fi
        printf '%s\0' "${arr[@]}" | xargs -0 -n1 -P${processes} sh -c 'bash process_vcf_chrX.sh "$1" $DX_PROJECT_CONTEXT_ID $mem $outdir $mingq $mindp $maxmiss' _
    else
        if [[ -z "${sex_file}" ]]; then
            echo "Need sex file"
            exit 1
        fi
        printf '%s\0' "${arr[@]}" | xargs -0 -n1 -P${processes} sh -c 'bash process_vcf_chrX_PAR.sh "$1" $DX_PROJECT_CONTEXT_ID $mem $outdir $mingq $mindp $maxmiss' _
    fi
    dx-jobutil-add-output output "$output" --class=string
}
