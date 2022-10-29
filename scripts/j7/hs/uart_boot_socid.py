#!/usr/bin/env python3
import binascii
import struct
import string
import sys

filename=sys.argv[1]
fp = open(filename, 'rt')
lines= fp.readlines()
fp.close()
bin_arr = [ binascii.unhexlify(x.rstrip()) for x in lines ]
bin_str = b"".join(bin_arr)
pubInfoStr='BB2B12B4B4B4B'
secInfoStr='BBHHH64B64B32B'
numBlocks = list(struct.unpack('I', bin_str[0:4]))
pubROMInfo = struct.unpack(pubInfoStr, bin_str[4:32])

print ("numBlocks")
if numBlocks:
    secROMInfo = struct.unpack(secInfoStr, bin_str[32:200])
print ('-----------------------')
print ('SoC ID Header Info:')
print ('-----------------------')
print ("NumBlocks :", numBlocks)
print ('-----------------------')
print ('SoC ID Public ROM Info:')
print ('-----------------------')
print ("SubBlockId :", pubROMInfo[0])
print ("SubBlockSize :", pubROMInfo[1])
tmpList = list(pubROMInfo[4:15])
hexList = [hex(i) for i in tmpList]
deviceName = ''.join(chr(int(c, 16)) for c in hexList[0:])
print ("DeviceName :", deviceName)
tmpList = list(pubROMInfo[16:20])
hexList = [hex(i) for i in tmpList]
deviceType = ''.join(chr(int(c, 16)) for c in hexList[0:])
print ("DeviceType :", deviceType)
dmscROMVer = list(pubROMInfo[20:24])
dmscROMVer.reverse()
print ("DMSC ROM Version :", dmscROMVer)
r5ROMVer = list(pubROMInfo[24:28])
r5ROMVer.reverse()
print ("R5 ROM Version :", r5ROMVer)
print ('-----------------------')
print ('SoC ID Secure ROM Info:')
print ('-----------------------')
print ("Sec SubBlockId :", secROMInfo[0])
print ("Sec SubBlockSize :", secROMInfo[1])
print ("Sec Prime :", secROMInfo[2])
print ("Sec Key Revision :", secROMInfo[3])
print ("Sec Key Count :", secROMInfo[4])
tmpList = list(secROMInfo[5:69])
tiMPKHash = ''.join('{:02x}'.format(x) for x in tmpList)
print ("Sec TI MPK Hash :", tiMPKHash)
tmpList = list(secROMInfo[69:133])
custMPKHash = ''.join('{:02x}'.format(x) for x in tmpList)
print ("Sec Cust MPK Hash :", custMPKHash)
tmpList = list(secROMInfo[133:167])
uID = ''.join('{:02x}'.format(x) for x in tmpList )
print ("Sec Unique ID :", uID )
