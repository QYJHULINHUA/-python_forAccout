#! /usr/bin/python
# coding:utf-8

import IHFAccountCenterSql
import json
from BaseHTTPServer import HTTPServer,BaseHTTPRequestHandler

class RequestHandler(BaseHTTPRequestHandler):
  def _writeheaders(self):
    self.send_response(200);
    self.send_header('Content-type','text/html');
    self.end_headers()


  def do_Head(self):
    self._writeheaders()

  def do_GET(self):
    self._writeheaders()
    

  def do_POST(self):
    self._writeheaders()

    length = self.headers.getheader('content-length');
    nbytes = int(length)
    data = self.rfile.read(nbytes)

    if self.path == '/1001':
      # 注册接口
      resucltCode = IHFAccountCenterSql.registerController(data)
      
      if  resucltCode == 1:
        self.wfile.write('注册成功')
      elif resucltCode == -1:
        self.wfile.write('电话号码为空')
      elif resucltCode == -2:
        self.wfile.write('手机号已注册')
      else:
        self.wfile.write('注册失败')

    elif self.path == '/1002':
      # 登录接口
      resucltCode = IHFAccountCenterSql.loginController(data)
      if type(resucltCode) == tuple:
        if len(resucltCode) > 0:
          accountInfo = resucltCode[0]
          keylist = ('USERID','name','age','sex','tel','password','email')
          dic = {}
          for x in xrange(7):
            key = keylist[x]
            value = accountInfo[x]
            dic[key] = value
          callBack = {"status":1,"data":dic}  
        else:
          callBack = {"status":-4,"data":'未知错误'} 
      elif resucltCode == -1:         #数据解析失败
        callBack = {"status":-1,"data":'数据解析失败'} 
      elif resucltCode == -2:         #请输入账户密码
        callBack = {"status":-2,"data":'请输入账户密码'} 
      elif resucltCode == -3:         #账户密码不正确
        callBack = {"status":-3,"data":'账户密码不正确'} 
      else:
        callBack = {"status":-4,"data":'未知错误'} 


      callBack = json.dumps(callBack) 
      self.wfile.write(callBack)  
        
    elif self.path == '/1003':
      # 修改密码
      callBack = IHFAccountCenterSql.modifPassword(data)
      callBack = json.dumps(callBack)
      self.wfile.write(callBack)

    elif self.path == '/1004':
      callBack = IHFAccountCenterSql.validationEmail(data) 
      callBack = json.dumps(callBack)
      self.wfile.write(callBack)

if __name__ == '__main__':
  IHFAccountCenterSql.creatDBWithName()
  IHFAccountCenterSql.createDBTableName()
  addr = ('',8765)
  server = HTTPServer(addr,RequestHandler)
  server.serve_forever()

    











