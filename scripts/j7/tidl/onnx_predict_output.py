###############################################################################
# @TIDL   : Example script to Reference output from MxNet for ONNX
# @Get from TIDL SDK, tested. Modified. 
# @Author : fredyzhang2018@gmail.com
# @DAate  :  20220420 
# Notice  : Floating point comparison for a specific list of layers
#           tested on python3.6 (officially 3.8)
###############################################################################
import mxnet as mx
import numpy as np
from collections import namedtuple
from mxnet.gluon.data.vision import transforms
from mxnet.contrib.onnx.onnx2mx.import_model import import_model
import os
import argparse
parser = argparse.ArgumentParser(description='My Arg Parser')
parser.add_argument('-m', '--model',                       default='../../test/testvecs/models/public/onnx/squeezenet1.1.onnx', help='Input Onnx model to load', required=False)
parser.add_argument('-i', '--image',                       default='../../test/testvecs/input/airshow.jpg', help='Input Image to infer', required=False)
parser.add_argument('-t', '--trace_enable',  type=int,     default=1, help='Set 1 to enable trace', required=False)
parser.add_argument('-d', '--dir_trace',                   default='trace/', help='Base Directory for trace', required=False)
parser.add_argument('-b', '--input_tensor_name',           default='data', help='Input tensor name', required=False)
parser.add_argument('-r', '--rgb_input',     type=int,     default=1, help='Input tensor RGB or BGR, set to 1 for RGB and 0 for BGR', required=False)
parser.add_argument('-p', '--pre_proc_type',     type=int, default=0, help='Pre-Processing type for Input', required=False)
args = vars(parser.parse_args())
print(args['model'])
# mx.test_utils.download('https://s3.amazonaws.com/model-server/inputs/kitten.jpg')
# mx.test_utils.download('https://s3.amazonaws.com/onnx-model-zoo/synset.txt')
with open('synset.txt', 'r') as f:
    labels = [l.rstrip() for l in f]
# Enter path to the ONNX model file
model_path= args['model']
sym, arg_params, aux_params = import_model(model_path)
Batch = namedtuple('Batch', ['data'])
def get_image(path, show=False):
    img = mx.image.imread(path, to_rgb=args['rgb_input'])
    if img is None:
        return None
    return img
def preprocess(img):
    transform_fn = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])
    img = transform_fn(img)
    img = img.expand_dims(axis=0)
    return img
def preprocess_1(img):
    transform_fn = transforms.Compose([
    transforms.Resize(224, keep_ratio=True),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize([0.5, 0.5, 0.5], [0.00390625, 0.00390625, 0.00390625])
    ])
    img = transform_fn(img)
    img = img.expand_dims(axis=0)
    return img
def predict(path):
    img = get_image(path, show=False)
    if args['pre_proc_type'] == 0 :
        img = preprocess(img)
    elif args['pre_proc_type'] == 1 :
        img = preprocess_1(img)
    mod.forward(Batch([img]))
    internal_dict = dict(zip(all_names, mod.get_outputs()))
    #print(internal_dict[output_names[0]])
    # Take softmax to generate probabilities
    scores = mx.ndarray.softmax(np.squeeze(internal_dict[output_names[0]])).asnumpy()
    if(args['trace_enable']):
        print('Writing')
        for name in all_names:
            act = internal_dict[name]
            act = act.asnumpy()
            maxval = max(act.ravel())
            minval = min(act.ravel())
            rng = max(np.abs(maxval), np.abs(minval))
            if minval >= 0 :
                scale = 255/rng if rng!=0 else 0
            else :
                scale = 127/rng if rng!=0 else 0
            #print(name, act.shape, minval, maxval)
            act_shape = act.shape
            file_name = name+str(act_shape)
            file_name = file_name.replace("/","_").replace("(","_").replace(")","").replace(", ","x").replace(",","x").replace(" ","_")+".y"
            file_name = "trace/"+file_name
            print(file_name, act_shape, minval, maxval, scale)
            with open(file_name+"float.bin",'wb') as file:
                act_float = act.astype(np.float32)
                act_float = np.asarray(act_float, order="C")
                file.write(act_float)
                file.close()
            file_name = name+str(act_shape[-2:])
            file_name = file_name.replace("/","_").replace("(","_").replace(")","").replace(", ","x").replace(",","x").replace(" ","_")+".y"
            file_name = "trace/"+file_name
            with open(file_name,'wb') as file:
                #act = np.round(act * scale) + 128
                act = np.round(act * scale)
                act = act.astype(np.uint8)
                act = np.asarray(act, order="C")
                file.write(act)
    # print the top-5 inferences class
    scores = np.squeeze(scores)
    a = np.argsort(scores)[::-1]
    print(a[0:5])
    for i in a[0:5]:
        print('class=%s ; probability=%f' %(labels[i],scores[i]))
# Determine and set context
if len(mx.test_utils.list_gpus())==0:
    ctx = mx.cpu()
else:
    ctx = mx.gpu(0)
output_names = sym.list_outputs()
#print('Output : ')
#print(output_names)
if args['trace_enable']:
    sym = sym.get_internals()
    blob_names = sym.list_outputs()
    sym_group = []
    for i in range(len(blob_names)):
        if blob_names[i] not in arg_params:
            x = sym[i]
            if blob_names[i] not in output_names:
                x = mx.symbol.BlockGrad(x, name=blob_names[i])
            sym_group.append(x)
    sym = mx.symbol.Group(sym_group)
all_names = sym.list_outputs()
# print('All Output : ')
# print(all_names)
# Load module
mod = mx.mod.Module(symbol=sym, data_names=(args['input_tensor_name'],), context=ctx, label_names=None)
mod.bind(for_training=False, data_shapes=[(args['input_tensor_name'], (1,3,224,224))],
        label_shapes=mod._label_shapes)

mod.set_params(arg_params, aux_params, allow_missing=True, allow_extra=True)
# Enter path to the inference image below
#img_path = 'kitten.jpg'
img_path = args['image']
predict(img_path)