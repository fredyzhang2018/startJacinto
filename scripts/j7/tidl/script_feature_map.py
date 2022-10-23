###############################################################################
# @TIDL   : Layer level Activation Comparisions. 
# @Get from TIDL SDK, tested. Modified. 
# @Author : fredyzhang2018@gmail.com
# @DAate  :  20220420 
# Notice  : run this on : utils/tidlModelImport
#           tested on python3.6 (officially 3.8)
###############################################################################
import numpy as np
import argparse
import matplotlib
import matplotlib.pyplot as plt
import os
import sys
import subprocess
import shutil
debug = 0
parser = argparse.ArgumentParser()
parser.add_argument('-im', '--import_cfg',
                    default='../../test/testvecs/config/import/public/caffe/tidl_import_jacintonet11v2.txt')
parser.add_argument('-in', '--infer_cfg', default='testvecs/config/infer/public/caffe/tidl_infer_jacintonet11v2.txt')
# TO DO Yet add support
parser.add_argument('-p', '--precision', default='8bit')
parser.add_argument('-o', '--outdir', default='comparison_output')
# parser.add_argument('-l', '--list_file',  default='testvecs/config/config_accuracy_list.txt')
args = parser.parse_args()

numParamBits = {
    "8bit": ['8'],
    "16bit": ['16']
}
def save_error_plot(float_output, fixed_output, axes):
    mx = np.max(float_data)
    mn = np.min(float_data)
    org_diff = (fixed_data - float_data)
    combined = np.vstack((float_data, fixed_data, org_diff)).T
    # #np.savetxt("figs\\"+str(i).zfill(4)+"_float.txt", combined, fmt='%10.6f, %10.6f, %10.6f')
    abs_diff = abs(fixed_data - float_data)
    maxIndex = np.argmax(abs_diff)
    max_abs_diff = np.max(abs_diff)
    mean_abs_diff = np.mean(abs_diff)
    var_abs_diff = np.var(abs_diff)
    axes.hist(abs_diff, color='blue', edgecolor='black', bins=60)
    # image_txt = "mean = " + str(mean) +", Var = "+ str(var) +", MAx = "+ str(mx)
    image_txt = "MeanAbsDiff=%7.4f, MaxAbsDiff=%7.4f, MaxVal=%7.3f" % (mean_abs_diff, max_abs_diff, mx)
    #plt.title(image_txt)
    axes.set_title(image_txt, fontdict = {'fontsize' : 8})
def save_pc_ref_plot(float_output, fixed_output, axes):
    axes.set_title("Float output Vs Fixed Output : Plot 1")
    axes.set_xlabel('Float Output')
    axes.set_ylabel('Fixed Output')
    axes.plot(float_output, fixed_output, '.')
def save_pc_ref_plot2(float_output, fixed_output, axes):
    axes.set_title("Float output Vs Fixed Output : Plot 2")
    axes.plot(float_output, "bs", label = "Float")
    axes.plot(fixed_output, "c.", label = "Fixed")
    axes.legend(loc='upper right', frameon=True)
current_dir = os.getcwd();
tidl_dir = os.path.abspath(os.path.join(current_dir, "../../../"))
import_dir = os.path.join(tidl_dir, "ti_dl/utils/tidlModelImport")
infer_dir = os.path.join(tidl_dir, "ti_dl/test")
output_directory = os.path.join(current_dir, args.outdir)
float_dir = os.path.join(current_dir, "out_float");
float_dir = os.path.join(float_dir, "");
fixed_dir = os.path.join(current_dir, "out_8bit");
fixed_dir = os.path.join(fixed_dir, "");
if sys.platform == 'win32':
    import_tool = 'out/tidl_model_import.out.exe'
    tb_tool = 'PC_dsp_test_dl_algo.out.exe'
    comment_lead = '::'
    shell_attribute = False
elif sys.platform == 'linux':
    import_tool = './out/tidl_model_import.out'
    tb_tool = './PC_dsp_test_dl_algo.out'
    comment_lead = '#'
    shell_attribute = True
else:
    msg(0, 'Unrecognised system: %s' % sys.platform)
    sys.exit(1)
if debug == 0 :
    if os.path.exists(os.path.join(current_dir, "out_8bit")):
        shutil.rmtree(os.path.join(current_dir, "out_8bit"))
    if os.path.exists(os.path.join(current_dir, "out_float")):
        shutil.rmtree(os.path.join(current_dir, "out_float"))
    if os.path.exists(output_directory):
        shutil.rmtree(output_directory)
    os.mkdir("out_8bit")
    os.mkdir("out_float")
    os.mkdir(output_directory)
    os.mkdir(os.path.join(output_directory, "activations"))
    # First do the import in floating point
    print(import_dir)
    os.chdir(import_dir)
    print("Floating Point import : Start")
    import_command_base = import_tool + " " + args.import_cfg;
    import_command_float = import_command_base + " --numParamBits 32"
    subprocess.call(import_command_float,shell=shell_attribute)
    print("Floating Point import : End")
    # Inference to collect layer level traces of floating point
    os.chdir(infer_dir)
    print("Floating Point inference : Start")
    infer_command_base = tb_tool + " s:" + args.infer_cfg + " --writeTraceLevel 3 --debugTraceLevel 1 "
    infer_config_float = infer_command_base + " --flowCtrl 1 " + "--traceDumpBaseName " + float_dir
    print(infer_config_float)
    subprocess.call(infer_config_float,shell=shell_attribute)
    print("Floating Point inference : End")
    # Delete other traces other than floating point
    for item in os.listdir(float_dir):
        if item.endswith(".y"):
            os.remove(os.path.join(float_dir, item))
    os.chdir(import_dir)
    import_command_fixed = import_command_base + " --numParamBits " + numParamBits[args.precision][0]
    print(import_command_fixed)
    subprocess.call(import_command_fixed,shell=shell_attribute)
    os.chdir(infer_dir)
    infer_config_fixed = infer_command_base + "--traceDumpBaseName " + fixed_dir
    print(infer_config_fixed)
    subprocess.call(infer_config_fixed,shell=shell_attribute)
    for item in os.listdir(fixed_dir):
        if item.endswith(".y"):
            os.remove(os.path.join(fixed_dir, item))
i = 0
for item in os.listdir(float_dir):
    fileHandle = open(os.path.join(fixed_dir, item), 'rb')
    fixed_data = np.fromfile(fileHandle, dtype=np.float32)
    fileHandle.close()
    fileHandle = open(os.path.join(float_dir, item), 'rb')
    float_data = np.fromfile(fileHandle, dtype=np.float32)
    fileHandle.close()
    fig = plt.figure(figsize=(10, 10))
    axes1 = plt.subplot2grid((16, 16), (0, 0), rowspan=6, colspan=7)
    axes2 = plt.subplot2grid((16, 16), (0, 8), rowspan=6, colspan=8)
    axes3 = plt.subplot2grid((16, 16), (8, 0), rowspan=8, colspan=16)
    save_error_plot(float_data, fixed_data, axes1)
    save_pc_ref_plot(float_data, fixed_data, axes2)
    save_pc_ref_plot2(float_data, fixed_data, axes3)
    filename = os.path.join(os.path.join(output_directory, "activations"), str(i).zfill(4) + "_activations.png");
    plt.savefig(filename)
    plt.clf()
    plt.close(fig)
    i = i + 1