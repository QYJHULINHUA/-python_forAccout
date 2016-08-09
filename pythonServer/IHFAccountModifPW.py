#! /usr/bin/python
# coding:utf-8


import smtplib
import random
from email.mime.text import MIMEText
from email.header import Header

def sendSecurityCode(receivers_email):
    mail_host = 'mail.ihefe.com'
    mail_user = 'hulinhua'
    mail_pw = 'HUhu7852'

    receivers = [receivers_email]
    securityCode = random.randint(100000, 999999)
    content = "尊敬的用户您好：为保护您的账户安全，请妥善保护您的验证码:%s"%str(securityCode)

    message = MIMEText(content, 'plain', 'utf-8')
    message['Subject'] = Header('验证码', 'utf-8')
    message['From'] = Header("hulinhua@ihefe.com", 'utf-8')
    message['To'] =  Header(receivers_email, 'utf-8')
    try:
        smtpObj = smtplib.SMTP()
        smtpObj.connect(mail_host,25)
        smtpObj.login(mail_user,mail_pw)
        smtpObj.sendmail(mail_user, receivers, message.as_string())

        return securityCode

    except Exception, e:
        return '发送邮箱失败'
    else:
        pass
    finally:
        pass
       


        











