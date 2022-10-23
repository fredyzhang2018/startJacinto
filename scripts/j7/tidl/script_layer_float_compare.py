###############################################################################
# @TIDL   : Layer level Activation Comparisions. 
# @Get from TIDL SDK, tested. Modified. 
# @Author : fredyzhang2018@gmail.com
# @DAate  :  20220420 
# Notice  : Floating point comparison for a specific list of layers
#           tested on python3.6 (officially 3.8)
###############################################################################
import numpy as np
import argparse
import matplotlib
import matplotlib.pyplot as plt
parser = argparse.ArgumentParser(description='My Arg Parser')
parser.add_argument('-i', '--in_file_list', default='trcae_files_list.txt', help='test file containinglist of files to compare', required=False)
args = vars(parser.parse_args())
#dir *float* /o:d /s/b
def save_error_plot(list,i, mean, var, mxd, mx):
    plt.hist(list, color = 'blue', edgecolor = 'black',bins=60)
    #image_txt = "mean = " + str(mean) +", Var = "+ str(var) +", MAx = "+ str(mx)
    image_txt = "MeanAbsDiff=%7.4f, MaxAbsDiff=%7.4f, MaxVal=%7.3f" %(mean, mxd, mx)
    plt.title(image_txt)
    plt.savefig("figs\\"+str(i).zfill(4)+"_abs_diff_hist.png")
    plt.clf()
def main():
    with open(args['in_file_list']) as f:
        content = f.readlines()
        f.close()
    print("%5s, %12s, %12s, %12s, %12s %12s, %12s, %12s" %("Idx", "Min", "Max", "max_abs_diff", "max_diff_idx", "mean_abs_diff",  "var_abs_diff", "Scale"))
    for i, line in enumerate(content):
        values = line.split()
        fileHandle = open(values[0], 'rb')
        tidl_data = np.fromfile(fileHandle, dtype=np.float32)
        fileHandle.close()
        fileHandle = open(values[1], 'rb')
        ref_data = np.fromfile(fileHandle, dtype=np.float32)
        fileHandle.close()
        mx = np.max(ref_data)
        mn = np.min(ref_data)
        org_diff = (tidl_data - ref_data)
        combined = np.vstack((ref_data, tidl_data, org_diff)).T
        np.savetxt("figs\\"+str(i).zfill(4)+"_float.txt", combined, fmt='%10.6f, %10.6f, %10.6f')
        abs_diff = abs(tidl_data - ref_data)
        maxIndex      = np.argmax(abs_diff)
        max_abs_diff  = np.max(abs_diff)
        mean_abs_diff = np.mean(abs_diff)
        var_abs_diff  = np.var(abs_diff)
        save_error_plot(abs_diff, i,mean_abs_diff,var_abs_diff,max_abs_diff,mx)
        rng = max(np.abs(mx), np.abs(mn))
        if(mn < 0):
            scale = 127/rng if rng!=0 else 0
            tidl_data = np.round(tidl_data * scale)
            tidl_data = tidl_data.astype(np.int8)
        else:
            scale = 255/rng if rng!=0 else 0
            tidl_data = np.round(tidl_data * scale)
            tidl_data = tidl_data.astype(np.uint8)
        tidl_data = np.asarray(tidl_data, order="C")
        with open(values[0]+"viz.y",'wb') as file:
            file.write(tidl_data)
            file.close()
        print("%5s, %12.5f, %12.5f, %12.5f, %12d, %12.5f, %12.5f %12.5f" %(i, mn, mx, max_abs_diff, maxIndex, mean_abs_diff,  var_abs_diff, scale))
if __name__ == "__main__":
    main()