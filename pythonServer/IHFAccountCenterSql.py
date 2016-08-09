
#coding=utf-8

import MySQLdb
import json
import IHFAccountModifPW

DB_Name = 'IHFAccountDB'
DB_table = 'accountTable'

# 验证邮箱信息
def validationEmail(inputData):
	jsonDic = json.loads(inputData)
	if type(jsonDic) == dict:
		accountID = jsonDic.get('accontIDStr','')
		emailStr = jsonDic.get('emailStr','')
		if len(accountID) == 11:
			sql = "SELECT * FROM IHFAccountDB.accountTable WHERE tel = '%s' and email = '%s';" %(accountID,emailStr)
		else:
			sql = "SELECT * FROM IHFAccountDB.accountTable WHERE USERID = '%s' and email = '%s';" %(accountID,emailStr)
		result = queryAccountinfomationWithSqlStr(sql)
		if result == ():
			return {'stauts':-2,'data':'请填写正确的账户和邮箱'}
		else:
			securityCode = IHFAccountModifPW.sendSecurityCode(emailStr)
			return {'stauts':1,'data':securityCode}
	else:
		return {'stauts':-1,'data':'验证失败'}


def modifPassword(inputData):
	jsonDic = json.loads(inputData)
	if type(jsonDic) == dict:
		accontIDStr = jsonDic.get('accontIDStr','')
		newPW = jsonDic.get('newPW','')

		if newPW == '' or accontIDStr == '':
			return {'stauts':-3,'data':'修改密码失败'}
			
		if len(accontIDStr) == 11:
			sql = "UPDATE IHFAccountDB.accountTable SET password='%s' WHERE tel = '%s'"%(newPW,accontIDStr)
		else:
			sql = "UPDATE IHFAccountDB.accountTable SET password='%s' WHERE USERID = '%s'"%(newPW,accontIDStr)
		result = updataMysql(sql)
		if result == -2:
			return {'stauts':-2,'data':'修改密码失败'}
		elif result == 1:
			return {'stauts':1,'data':'修改密码成功'}
	else:
		return {'stauts':-1,'data':'修改密码失败'}



def loginController(inputData):
	jsonDic = json.loads(inputData)
	if type(jsonDic) == dict:
		result = queryAccountinfomation(jsonDic)
		if result == -2:
			return -2;#请输入账户密码
		elif result == ():
			return -3;#账户密码不正确
		elif type(result) == tuple and result:
			return result;
		else:
			return -4;# 我也不知道怎么回事啦，反正是失败了
	else:
		return -1;#登录失败	


def queryAccountinfomationWithSqlStr(sqlString):
	con_db = conDB(DB_Name)
	cur = con_db.cursor()
	cur.execute(sqlString)
	results = cur.fetchall()
	cur.close()
	con_db.close()
	return results

def updataMysql(sqlString):
	try:
		con_db = conDB(DB_Name)
		cur = con_db.cursor()
		cur.execute(sqlString)
		con_db.commit()
		cur.close()
		con_db.close()
		return 1
	except Exception, e:
		print "Mysql Error %d: %s" % (e.args[0], e.args[1])
		return -2
	else:
		pass
	finally:
		pass
	
			
# 查询账户信息
def queryAccountinfomation(jsonDic):
	accountID = jsonDic.get('accountID','')
	password = jsonDic.get('password','')
	if accountID == '' and password == '':
		return -2;
	else:	
		con_db = conDB(DB_Name)
		cur = con_db.cursor()
		sql = "SELECT * FROM IHFAccountDB.accountTable WHERE tel = '%s' and password = '%s';" %(accountID,password)
		# sql = "SELECT * FROM IHFAccountDB.accountTable WHERE tel = '%s'"%tel
		cur.execute(sql)
		results = cur.fetchall()
		cur.close()
		con_db.close()
		return results

def registerController(inputData):
	jsonDic = json.loads(inputData)
	if type(jsonDic) == dict:
		tel = jsonDic.get('tel','');
		if tel == '':
			return -1;#电话号码为空
		else:
			que_tel = queryAccountIsEixit(tel)
			print que_tel
			if que_tel == ():
				insetAccountDataToDatabase(jsonDic)
				return 1;
			else:
				return -2;#用户手机号已存在
			
	else:
		return 0;	
	
#  创建数据库
def creatDBWithName():
	conn = MySQLdb.connect(host='localhost',user='root',passwd='huhu7852')
	sursorhah = conn.cursor()
	sqlStr = """create database if not exists """ + DB_Name;	
	sursorhah.execute(sqlStr)
	conn.close()

def createDBTableName():
	con_db = conDB(DB_Name)
	cur = con_db.cursor()
	sqlStr = """CREATE TABLE IF NOT EXISTS %s(USERID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,name TEXT,age TEXT,sex TEXT,tel TEXT ,password TEXT,email TEXT) CHARACTER SET utf8""" %DB_table
	cur.execute(sqlStr)
	con_db.commit()
	cur.close()
	con_db.close()

def queryAccountIsEixit(tel):
	con_db = conDB(DB_Name)
	cur = con_db.cursor()
	sql = "SELECT * FROM IHFAccountDB.accountTable WHERE tel = '%s'"%tel
	cur.execute(sql)
	results = cur.fetchall()
	cur.close()
	con_db.close()
	return results

#插入数据
def insetAccountDataToDatabase(jsonDic):
	tel = jsonDic.get('tel','');
	age = jsonDic.get('age','');
	name = jsonDic.get('name','');
	sex = jsonDic.get('sex','');
	password = jsonDic.get('password','')
	email = jsonDic.get('email','')

	con_db = conDB(DB_Name)
	cur = con_db.cursor()
	sql = """INSERT INTO `IHFAccountDB`.`accountTable` (`name`, `age`, `sex`, `tel` ,`password` ,`email`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s');"""%(name,age,sex,tel,password,email)
	cur.execute(sql)
	con_db.commit()
	cur.close()
	con_db.close()



conDB = lambda dbname :	MySQLdb.connect(host='localhost',port = 3306,user='root',passwd='huhu7852',db = dbname,use_unicode=True,charset='utf8')


print 'jinru'


