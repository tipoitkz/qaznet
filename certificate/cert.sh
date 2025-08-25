#!/bin/bash
read -p "Input 1 - install, 2 -delete " key

source="https://sts.kz/storage/media/Unified_State_Internet_Access_Gateway_RtnCtVF.cer"

version=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

if [ "$version" == '"Ubuntu"' ]; then 
    dest="/usr/local/share/ca-certificates/Unified_State_Internet_Access_Gateway.crt"
    updateCMD="update-ca-certificates"
else
    dest="/etc/pki/ca-trust/source/anchors/Unified_State_Internet_Access_Gateway.crt"
    updateCMD="update-ca-trust"
fi

case $key in

  1)
    if [ $version == '"Ubuntu"' ]; then 
        if dpkg -l | grep wget
            then
                wget --output-document $dest $source
                $updateCMD
            else
                echo "wget ISN'T installed. Please install it"
        fi
    else
        if rpm -q wget
            then
                wget --output-document $dest $source
                $updateCMD
            else
                echo "wget ISN'T installed. Please install it"
        fi
    fi
    ;;

  2)
    rm $dest
    #pkcs11=$(trust list | grep "Unified State Internet Access Gateway" -B 3 | grep pkcs11)
    #trust anchor --remove --verbose $pkcs11
    $updateCMD
    ;;

esac
