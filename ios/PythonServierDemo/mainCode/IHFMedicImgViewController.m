//
//  IHFMedicImgViewController.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/15.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFMedicImgViewController.h"
#import "YX_Net.h"
#import "YX_ReqModel.h"
#import "MBProgressHUD.h"
#import "IHF_NewSeriesView.h"
#import "IHFMDicViewController.h"

@interface IHFMedicImgViewController ()<IHF_NewSeriesViewDelegate>
{
    MBProgressHUD *hud;
    IHF_NewSeriesView *seriesView;
}

@end

@implementation IHFMedicImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"影像列表";
    self.navigationController.navigationBarHidden = NO;
    
    seriesView = [[IHF_NewSeriesView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    seriesView.delegate = self;
    [self.view addSubview:seriesView];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self reloadRisData];
    });
    
}


- (void)reloadRisData
{
    
    __weak typeof(self) weakSelf = self;
    [YX_Net loginWith:nil pw:nil callBack:^(NSNumber *success, id response) {
        if (success.boolValue) {
            NSDictionary *loginDic = response[0];
            YX_ReqModel_login * login = [YX_ReqModel_login getShareInstance];
            login.accessToken = loginDic[@"accessToken"];
            login.userright = loginDic[@"userright"];
            login.useruid = loginDic[@"useruid"];
            if (login.accessToken && [login.accessToken isKindOfClass:[NSString class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [seriesView requestStudyList_Current:nil];
                    [hud hideAnimated:YES];
                });
                
            }else
            {
                [weakSelf showHUD:NO msg:@"获取数据失败"];
            }
            
        }else
        {
            [weakSelf showHUD:NO msg:@"获取数据失败"];
        }
        
    }];
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

- (void)SeriesViewSelectedIndex:(NSIndexPath *)indexPath Series:(IHFPatientModel *)seriesModel
{
    
    IHFMDicViewController *meidcVC = [[IHFMDicViewController alloc] init];
    [self presentViewController:meidcVC animated:YES completion:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            [meidcVC setPatientModelF:seriesModel];
        });
        
        [seriesView removeFromSuperview];
        seriesView = nil;
    }];
    
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
