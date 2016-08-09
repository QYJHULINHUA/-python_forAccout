//
//  ViewController.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/7/29.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "ViewController.h"
#import "IHFMAccountData.h"
#import "IHFPatientListVC.h"
#import "IHFAccountNet.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (IBAction)touchBtn:(UIButton *)sender {
    

    NSDictionary *registParamDic = @{@"name":@"胡林华",@"tel":@"18916259020",@"sex":@"男",@"age":@"24"};
    
    [IHFAccountNet registeredAPI:registParamDic callBack:^(NSNumber *success, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _callBackLabel.text = response;
        });
    }];

 
}
- (IBAction)denglu:(id)sender {
    
    [IHFAccountNet loginAPI:nil callBack:^(NSNumber *success, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _callBackLabel.text = response;
        });
    }];
}

- (IBAction)changPW:(UIButton *)sender {
    
    [IHFAccountNet changePasswordAPI:nil callBack:^(NSNumber *success, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _callBackLabel.text = response;
        });
    }];
}


- (void)loginFailure
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录" message:@"登录失败" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    


}

- (void)loginSuccess
{
    

    IHFPatientListVC *patientVC = [[IHFPatientListVC alloc] initWithNibName:@"IHFPatientListVC" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:patientVC];
    [self presentViewController:nav animated:YES completion:nil];

    
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
