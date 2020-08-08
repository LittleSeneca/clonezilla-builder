#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
workspace_config () {
    export git_dir=$(pwd)
    export workspace_dir=/tmp/clonezilla_workspace
    export clonezilla_original="clonezilla-live-20200703-focal-amd64.iso"
    export live_bash_dir=${git_dir}/live
    export squashfs_dir=${workspace_dir}/squashfs
    export squashfs_live_dir=${squashfs_dir}/lib/live/mount/medium/live
    export squashfs_file=${workspace_dir}/combine/live/filesystem.squashfs
    export clonezilla_final="Clonezilla-live-SEL-focal-amd64.iso"
    clonezilla_iso_url="https://osdn.net/frs/redir.php?m=constant&f=clonezilla%2F73265%2F${clonezilla_original}"
    if [[ -d ${workspace_dir} ]]
        then
            rm -rf ${workspace_dir}
            mkdir ${workspace_dir}
            mkdir ${workspace_dir}/mount
            mkdir ${workspace_dir}/combine
        else
            mkdir ${workspace_dir}
            mkdir ${workspace_dir}/mount
            mkdir ${workspace_dir}/combine
    fi
    cd ${workspace_dir}
    wget -O ${clonezilla_original} ${clonezilla_iso_url}
    mount -o loop ${clonezilla_original} ${workspace_dir}/mount
    cp -rf ${workspace_dir}/mount/* ${workspace_dir}/combine/
    umount ${workspace_dir}/mount
}
merge_modifications () {
    cp -rf ${git_dir}/boot/* ${workspace_dir}/combine/boot/
    cp -rf ${git_dir}/syslinux/* ${workspace_dir}/combine/syslinux/
    cp -rf ${git_dir}/EFI/* ${workspace_dir}/combine/EFI/
    cp -rf ${live_bash_dir}/* ${workspace_dir}/combine/live/
}
build_iso () {
    apt install xorriso isolinux -y 
    cd ${workspace_dir}/combine
    xorriso -as mkisofs -R -r -J -joliet-long -l \
    -graft-points live=${live_bash_dir} \
    -cache-inodes -iso-level 3 \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -partition_offset 16 -A 'Clonezilla live CD' \
    -b syslinux/isolinux.bin \
    -c syslinux/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -eltorito-alt-boot \
    --efi-boot boot/grub/efi.img \
    -isohybrid-gpt-basdat \
    -isohybrid-apm-hfsplus \
    ./ > ${workspace_dir}/${clonezilla_final}
    echo "${clonezilla_final} has been saved to ${workspace_dir}"
}

workspace_config
merge_modifications
build_iso