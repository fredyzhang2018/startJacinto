from PIL import Image
from numpy import *
import re
from pylab import *
import cv2
import matplotlib
import numpy
from scipy.io import *

def draw_flow(im,imRGB,flow,step=16):
    h,w = im.shape[:2]
    y,x = mgrid[step/2:h:step,step/2:w:step].reshape(2,-1)
    x = array(x,'int')
    y = array(y,'int')
    fx,fy = flow[y,x].T

    lines = vstack([x,y,x+fx,y+fy]).T.reshape(-1,2,2)
    lines = int32(lines)

    #vis = cv2.cvtColor(im,cv2.COLOR_GRAY2BGR)
    vis = imRGB
    for (x1,y1),(x2,y2) in lines:
        if ((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2))>3.0:
            cv2.line(vis,(x1,y1),(x2,y2),(0,255,0),1)
            cv2.circle(vis,(x1,y1),1,(0,255,0),-1)
    return vis
cap = cv2.VideoCapture('.//IMG_1.avi')
im = cap.read()
map2 = im[1]
map2 = cv2.resize(im[1],(960,540))
map2_gray = dot(map2[..., :], [0.299, 0.587, 0.114])
# map2_gray_t = cv2.cvtColor(map2,cv2.COLOR_BGR2GRAY)
k = 0
while 1:
    im = cap.read()
    #im = cap.read()
    #im = cap.read()
    #im = cap.read()
    k = k+1
    if(im==[]):
        break
    map1 = im[1]
    map1 = cv2.resize(im[1], (960, 540))
    map1_gray = dot(map1[...,:],[0.299,0.587,0.114])
    #map1_gray_t = cv2.cvtColor(map1,cv2.COLOR_BGR2GRAY)
    #flow = cv2.calcOpticalFlowFarneback(map1_gray,map2_gray,None,0.5,3,15,3,5,1.2,0)
    flow = cv2.calcOpticalFlowFarneback(map2_gray,map1_gray,None,0.5,3,15,3,5,1.2,0)
    savemat('Loptmat'+str(k)+'.mat',{'OP':array(flow)})
    cv2.imshow('O',draw_flow(map1_gray,map1,flow,10))
    cv2.waitKey(0)
    map2 = im[1]
    map2 = cv2.resize(im[1], (960, 540))
    map2_gray = dot(map2[..., :], [0.299, 0.587, 0.114])

