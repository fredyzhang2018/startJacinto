"""
/*
 *
 * Copyright (c) 2017 Texas Instruments Incorporated
 *
 * All rights reserved not granted herein.
 *
 * Limited License.
 *
 * Texas Instruments Incorporated grants a world-wide, royalty-free, non-exclusive
 * license under copyrights and patents it now or hereafter owns or controls to make,
 * have made, use, import, offer to sell and sell ("Utilize") this software subject to the
 * terms herein.  With respect to the foregoing patent license, such license is granted
 * solely to the extent that any such patent is necessary to Utilize the software alone.
 * The patent license shall not apply to any combinations which include this software,
 * other than combinations with devices manufactured by or for TI ("TI Devices").
 * No hardware patent is licensed hereunder.
 *
 * Redistributions must preserve existing copyright notices and reproduce this license
 * (including the above copyright notice and the disclaimer and (if applicable) source
 * code license limitations below) in the documentation and/or other materials provided
 * with the distribution
 *
 * Redistribution and use in binary form, without modification, are permitted provided
 * that the following conditions are met:
 *
 * *       No reverse engineering, decompilation, or disassembly of this software is
 * permitted with respect to any software provided in binary form.
 *
 * *       any redistribution and use are licensed by TI for use only with TI Devices.
 *
 * *       Nothing shall obligate TI to provide you with source code for the software
 * licensed and provided to you in object code.
 *
 * If software source code is provided to you, modification and redistribution of the
 * source code are permitted provided that the following conditions are met:
 *
 * *       any redistribution and use of the source code, including any resulting derivative
 * works, are licensed by TI for use only with TI Devices.
 *
 * *       any redistribution and use of any object code compiled from the source code
 * and any resulting derivative works, are licensed by TI for use only with TI Devices.
 *
 * Neither the name of Texas Instruments Incorporated nor the names of its suppliers
 *
 * may be used to endorse or promote products derived from this software without
 * specific prior written permission.
 *
 * DISCLAIMER.
 *
 * THIS SOFTWARE IS PROVIDED BY TI AND TI'S LICENSORS "AS IS" AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL TI AND TI'S LICENSORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

File: tidl_image_resize.py
Description: Resizes images of arbitrary size to required size using OpenCV

EXAMPLE USAGE:
-------------

python tidl_image_resize.py --input_file=<path of input .jpg/.png/.bmp, mandatory> \
                             --resize_width=<width of output> \
                             --resize_height=<height of output> \
                             --output_file=<path of output binary file, optional>


python tidl_image_resize.py --input_file="airshow.jpg" --resize_width=256 --resize_height=256

By default, the resulting output will be named as airshow_256x256.png

"""
import sys
import cv2
import numpy as np

error_msg1 = "python tidl_image_resize.py --input_file=airshow.jpg --resize_width=256 --resize_height=256"

def tidl_image_resize(input_file, resize_width, resize_height, output_file):

    img = cv2.imread(input_file)

    resize_img = cv2.resize(img, (resize_width, resize_height), 0, 0, cv2.INTER_AREA);

    cv2.imwrite(output_file, resize_img)

if __name__ == '__main__':
    args = sys.argv[1:]
    
    if(len(args) < 3):
        print("Example Usage:")
        print(error_msg1)

    else:
        output_file = ""
        input_file = ""
    
        for arg in args:
            opt, value = arg.split("=")
        
            if(opt == "--input_file"):
                input_file = value
            if(opt == "--resize_width"):
                resize_width = int(value,10)
            if(opt == "--resize_height"):
                resize_height = int(value,10)
            if(opt == "--output_file"):
                output_file = value
    
        if output_file == "":
            name, ext = input_file.split(".")
            output_file = name + "_" + str(resize_width) + "x" + str(resize_height) + ".png"

        print("Resizing image " + input_file)
        tidl_image_resize(input_file, resize_width, resize_height, output_file)
        print("Done!")
        
