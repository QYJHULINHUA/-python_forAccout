//
//  IHFSignUpViewController.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/5.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFSignUpViewController.h"
#import "IHFTextFileldView.h"
#import "MBProgressHUD.h"
#import "IHFAccountNet.h"


#define heighSpace 50

@interface IHFSignUpViewController ()
{
    IHFTextFileldView *nameTextfile;
    IHFTextFileldView *ageTextField;
    IHFTextFileldView *sexTextField;
    IHFTextFileldView *telTextField;
    IHFTextFileldView *passwordTextField;
    IHFTextFileldView *emailTextField;
    MBProgressHUD *hud;
    
}

@end

@implementation IHFSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.navigationController.navigationBar.topItem.title = @"返回";
    self.title = @"注册";
    [self initUIView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bacgroudClick1:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)initUIView
{
    nameTextfile = [[IHFTextFileldView alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    nameTextfile.placeholderLable = @"姓名";
    [self.view addSubview:nameTextfile];
    
    ageTextField = [[IHFTextFileldView alloc] initWithFrame:CGRectMake(100, 100+(1 * heighSpace), 200, 30)];
    ageTextField.placeholderLable = @"年龄";
    [self.view addSubview:ageTextField];
    
    
    sexTextField = [[IHFTextFileldView alloc] initWithFrame:CGRectMake(100, 100+(2 * heighSpace), 200, 30)];
    sexTextField.placeholderLable = @"性别";
    [self.view addSubview:sexTextField];
    
    
    telTextField = [[IHFTextFileldView alloc] initWithFrame:CGRectMake(100, 100+(3 * heighSpace), 200, 30)];
    telTextField.placeholderLable = @"电话";
    [self.view addSubview:telTextField];
    
    
    passwordTextField = [[IHFTextFileldView alloc] initWithFrame:CGRectMake(100, 100+(4 * heighSpace), 200, 30)];
    passwordTextField.placeholderLable = @"密码";
    [self.view addSubview:passwordTextField];
    
    
    emailTextField = [[IHFTextFileldView alloc] initWithFrame:CGRectMake(100, 100+(5 * heighSpace), 200, 30)];
    emailTextField.placeholderLable = @"邮箱";
    [self.view addSubview:emailTextField];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100+(7 * heighSpace), 200, 30)];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"注册" forState:normal];
    [btn addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}


-(void)bacgroudClick1:(id)sender
{
    [nameTextfile resignFirstResponderr];
    [ageTextField resignFirstResponderr];
    [sexTextField resignFirstResponderr];
    [telTextField resignFirstResponderr];
    [passwordTextField resignFirstResponderr];
    [emailTextField resignFirstResponderr];

}

- (void)zhuce
{

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self bacgroudClick1:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *name = nameTextfile.textFileLabel;
        NSString *age = ageTextField.textFileLabel;
        NSString *sex = sexTextField.textFileLabel;
        NSString *password = passwordTextField.textFileLabel;
        NSString *email = emailTextField.textFileLabel;
        NSString *tel = telTextField.textFileLabel;
        BOOL isnull = name && age && sex && password && email && tel;
        if (isnull) {
            __weak typeof(self) weakself = self;
            NSDictionary *dic = @{@"name":name,@"age":age,@"sex":sex,@"password":password,@"email":email,@"tel":tel};
            [IHFAccountNet registeredAPI:dic callBack:^(NSNumber *success, id response) {
                [weakself showHUD:success.boolValue msg:response];
            }];
        }else
        {
            [self showHUD:NO msg:@"请填写完整注册信息"];
        }
        
    });
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
