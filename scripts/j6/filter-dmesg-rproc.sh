#!/bin/bash

dmesg | sed -n \
            -e '/iommu/p' \
            -e '/remoteproc/p' \
            -e '/rproc/p' \
            -e '/Mounted root/p' \
            -e '/virtio/p' \
            -e '/no idle/p' \
            -e '/no reset/p' \
            | uniq
