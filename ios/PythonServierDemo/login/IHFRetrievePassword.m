//
//  IHFRetrievePassword.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/8.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFRetrievePassword.h"
#import "IHFTextFileldView.h"
#import "MBProgressHUD.h"
#import "IHFAccountNet.h"

@interface IHFRetrievePassword ()
{
    IHFTextFileldView *accountID;
    IHFTextFileldView *email;
    
    IHFTextFileldView *yanzhengma;
    IHFTextFileldView *newPW;
    IHFTextFileldView *newPW_Again;
    MBProgressHUD *hud;
    
    NSDictionary *retrieveDic;
    
    UIScrollView *scroollView;
}

@end

@implementation IHFRetrievePassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"返回";
    self.title = @"找回密码";
    [self creatScrlloview];
    
    

}

- (void)dealloc
{
    [hud removeFromSuperview];
    [accountID removeFromSuperview];
    [email removeFromSuperview];
    [yanzhengma removeFromSuperview];
    [newPW removeFromSuperview];
    [newPW_Again removeFromSuperview];
    [scroollView removeFromSuperview];
    hud = nil;
    accountID = nil;
    email = nil;
    yanzhengma = nil;
    newPW = nil;
    newPW_Again = nil;
    scroollView = nil;
}

- (void)creatScrlloview
{
    scroollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scroollView.contentSize = CGSizeMake(scroollView.frame.size.width * 2, scroollView.frame.size.height);
    scroollView.scrollEnabled = NO;
    [self.view addSubview:scroollView];
    [self initUIView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bacgroudClick1:)];
    [scroollView addGestureRecognizer:tapGesture];
}


- (void)initUIView
{
    
    accountID = [[IHFTextFileldView alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    accountID.placeholderLable = @"帐号／手机号";
    [scroollView addSubview:accountID];
    
    email = [[IHFTextFileldView alloc] initWithFrame:CGRectMake(100, 150, 200, 30)];
    email.placeholderLable = @"邮箱";
    [scroollView addSubview:email];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 200, 30)];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"发送验证码至邮箱" forState:normal];
    [btn addTarget:self action:@selector(queding) forControlEvents:UIControlEventTouchUpInside];
    [scroollView addSubview:btn];
    
    
}

- (void)commit
{
    [self bacgroudClick1:nil];
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *newPWStr = newPW.textFileLabel;
        NSString *newPW_AgainStr = newPW_Again.textFileLabel;
        NSString *codeStr = yanzhengma.textFileLabel;
        __weak typeof(self) weakself = self;
        if (newPWStr && newPW_AgainStr) {
            if ([newPWStr isEqualToString:newPW_AgainStr]) {
                NSNumber *str = retrieveDic[@"SecurityCode"];
                if ([codeStr isEqualToString:str.stringValue]) {
                    
                    NSDictionary *dic = @{@"accontIDStr":retrieveDic[@"accontIDStr"],@"newPW":newPWStr};
                    [IHFAccountNet changePasswordAPI:dic callBack:^(NSNumber *success, id response) {
                        [weakself showHUD:success.boolValue msg:response];
                    }];
                    
                }
                else
                {
                    [weakself showHUD:NO msg:@"验证码输入错误"];
                }
            }else
            {
                [weakself showHUD:NO msg:@"请重新输入密码"];
            }
        }else
        {
            [weakself showHUD:NO msg:@"请输入新密码"];
        }
    });
    
}

- (void)queding
{
    [self bacgroudClick1:nil];
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *accontIDStr = accountID.textFileLabel;
        NSString *emailStr = email.textFileLabel;
        BOOL isnull = accontIDStr && emailStr;
        if (isnull) {
            __weak typeof(self) weakself = self;
            NSDictionary *dic = @{@"accontIDStr":accontIDStr,@"emailStr":emailStr};
            [IHFAccountNet validationEmailAPI:dic callBack:^(NSNumber *success, id response) {
                if (success.boolValue) {
                 
                    NSNumber *code = response;
                    retrieveDic = @{@"accontIDStr":accontIDStr,@"SecurityCode":code};
                    [weakself showHUD:YES msg:@"验证码已发送至邮箱"];

                    
                    
                }else
                {
                    [weakself showHUD:NO msg:response];
                }
                
            }];
        }else
        {
            [self showHUD:NO msg:@"请输入帐号邮箱"];
        }
        
    });
    
}

- (void)showHUD:(BOOL)issuccess msg:(NSString *)hudMsg
{
    NSString *imgName = issuccess? @"Checkmark":@"errormark";
    UIImage *image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hudMsg == nil) {
            [hud hideAnimated:YES];
        }else
        {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:image];
            hud.square = YES;
            hud.label.text = NSLocalizedString(hudMsg, @"HUD done title");
            [hud hideAnimated:YES afterDelay:2.f];
            if ([hudMsg isEqualToString:@"验证码已发送至邮箱"] ) {
                [self scroolviewoffset];
            }
        }
        
    });
    
}

- (void)scroolviewoffset
{
    CGFloat w = self.view.frame.size.width;
    
    
    
    newPW = [[IHFTextFileldView alloc] initWithFrame:CGRectMake(w+100, 150, 200, 30)];
    newPW.placeholderLable = @"请输入新密码";
    [scroollView addSubview:newPW];
    
    newPW_Again = [[IHFTextFileldView alloc] initWithFrame:CGRectMake(w+100, 200, 200, 30)];
    newPW_Again.placeholderLable = @"确认输入新密码";
    [scroollView addSubview:newPW_Again];
    
    
    yanzhengma = [[IHFTextFileldView alloc] initWithFrame:CGRectMake(w+100, 250, 200, 30)];
    yanzhengma.placeholderLable = @"请输入验证码";
    [scroollView addSubview:yanzhengma];
    
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(w+100, 350, 200, 30)];
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 setTitle:@"提交" forState:normal];
    [btn1 addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [scroollView addSubview:btn1];
    
    scroollView.contentOffset = CGPointMake(scroollView.frame.size.width, 0);
}

-(void)bacgroudClick1:(id)sender
{
    [accountID resignFirstResponderr];
    [email resignFirstResponderr];
    [yanzhengma resignFirstResponderr];
    [newPW resignFirstResponderr];
    [newPW_Again resignFirstResponderr];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
