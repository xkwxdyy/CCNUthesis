# 编码转换工具，将路径下所有".c .h .cpp .hpp .java"文件都转为 utf-8 格式
#i!/usr/bin/env python3
# -*- coding:utf-8 -*-
import os 
import sys 
import codecs 
import chardet 
 
gErrArray = []
 
def convert(fileName, filePath,out_enc="utf-8"): 
  try: 
    content=codecs.open(filePath,'rb').read()
    source_encoding=chardet.detect(content)['encoding']
    # print ("fileName:%s \tfileEncoding:%s" %(fileName, source_encoding))
    print("{0:50}{1}".format(fileName, source_encoding))
    
    if source_encoding != None:
      if source_encoding == out_enc:
        return
      content=content.decode(source_encoding).encode(out_enc)
      codecs.open(filePath,'wb').write(content)
    else :
      gErrArray.append("can not recgonize file encoding %s" % filePath)
  except Exception as err: 
    gErrArray.append("%s:%s"%(filePath, err))
  
def explore(dir): 
  print("\r\n===============================================================")
  print("{0:50}{1}".format('fileName', 'fileEncoding'))
  print("===============================================================")
  for root,dirs,files in os.walk(dir): 
    for file in files:
      suffix = os.path.splitext(file)[1]
      if suffix == '.tex' or suffix == '.def' or suffix == '.sty' or suffix == '.cls': 
        path=os.path.join(root,file)
        convert(file, path)
  
def main():     
  #explore(os.getcwd()) 
  filePath = input("请输入要转换编码的文件夹路径: \n")
  explore(filePath)
  print('\r\n---------错误统计------------')
  for index,item in enumerate(gErrArray):
    print(item)
  print('\r\n        共%d个错误！'%(len(gErrArray)))
  if(len(gErrArray) > 0):
    print("出现错误时，可手动找到错误文件，用notepad++打开后，点击编码，改为utf-8保存")
  print('\r\n-----------------------------')
if __name__=="__main__": 
  while True:
    main()
    input("\r\n########### 按回车键继续转换!!! ###########\r\n")