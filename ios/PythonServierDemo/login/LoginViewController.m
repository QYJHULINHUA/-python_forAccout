//
//  LoginViewController.m
//  iChat
//
//  Created by ihefe－song on 15/9/9.
//  Copyright (c) 2015年 ihefe29. All rights reserved.
//

#import "LoginViewController.h"
#import "IHFSignUpViewController.h"
#import "IHFRetrievePassword.h"
#import "MBProgressHUD.h"
#import "IHFAccountNet.h"
#import "IHFAccountData.h"


@interface LoginViewController ()
{
    MBProgressHUD *hud;
}

@end


//为了兼容CALayer 的KVC ，你得给CALayer增加一个分类,这里没有单独写分类，只是在OrderKeyboard里增加了此项扩展
@implementation CALayer (Additions)
- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _passwordView.delegate = self;
    _accontView.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bacgroudClick:)];
    [self.view addGestureRecognizer:tapGesture];

   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    _loginBtn.layer.cornerRadius = 20;

}
- (IBAction)zcl_forgetPasswordAction:(UIButton *)sender {
    IHFRetrievePassword  *RetrievePassword = [IHFRetrievePassword new];
    [self.navigationController pushViewController:RetrievePassword animated:YES];
}



-(void)bacgroudClick:(id)sender
{
   
    if([self.accontView isFirstResponder]) {
        [self.accontView resignFirstResponder];
    }
    if ([self.passwordView isFirstResponder]) {
        [self.passwordView resignFirstResponder];
    }
}


#pragma mark - textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length>=16) {
        if (string.length>=1) {
            return NO;
        }
        return YES;
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
 
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
   
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25f animations:^{
        self.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

   
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////获取键盘高度方法。（收藏了吧，不过貌似有问题，静候大神解决，）
- (CGFloat)visibleKeyboardHeight {
    
    
    
    UIWindow *keyboardWindow = [UIApplication sharedApplication].keyWindow;
    
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            
            keyboardWindow = testWindow;
            
            break;
            
        }
        
    }
    
    
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")])
            
            return possibleKeyboard.bounds.size.height;
        
    }
    
    
    
    return 0;
    
}

#pragma mark - 登陆
- (IBAction)zcl_loginAction:(UIButton *)sender {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loginIn];
}

#pragma mark - 注册
- (IBAction)Register:(id)sender
{
    IHFSignUpViewController *regiseterVC = [IHFSignUpViewController new];
    [self.navigationController pushViewController:regiseterVC animated:YES];
}

- (void)loginIn {
    if ([_passwordView.text isEqual:@""] || [_accontView.text isEqual:@""]) {
        [self showHUD:NO msg:@"请输入账户密码"];
    }else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __weak typeof(self) weakself = self;
            NSString *accontStr = _accontView.text;
            NSString *pwWord    = _passwordView.text;
            NSDictionary *dic = @{@"accountID":accontStr,@"password":pwWord};
            
            [IHFAccountNet loginAPI:dic callBack:^(NSNumber *success, id response) {
                if (!success.boolValue) {
                    [weakself showHUD:NO msg:response];
                }else
                {
                    [IHFAccountData getShareSingle].accountInfoDic = response;
                    [weakself showHUD:YES msg:@"登录成功"];
                }
                
            }];
        });
        
    }
    
}

- (void)showHUD:(BOOL)issuccess msg:(NSString *)hudMsg
{
    NSString *imgName = issuccess? @"Checkmark":@"errormark";
    UIImage *image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:image];
        hud.square = YES;
        hud.label.text = NSLocalizedString(hudMsg, @"HUD done title");
        [hud hideAnimated:YES afterDelay:2.f];
    });
    
}


- (IBAction)forgot:(id)sender {

    

}

- (void)zcl_sendDeviceTokenWithUid:(NSString *)user_id
{
   
}

- (void)zcl_checkVesion
{
    
}









@end
