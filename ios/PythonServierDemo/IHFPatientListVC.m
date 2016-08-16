//
//  IHFPatientListVC.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/2.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFPatientListVC.h"
#import "AFNetworking.h"
#import "IHFMAccountData.h"

@interface IHFPatientListVC ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation IHFPatientListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
//    [self getPatientList];
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)getPatientList
{
    NSString *suffiStr = @"/image/studyList";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kNEWIP,suffiStr];
    NSString *token = [IHFMAccountData shareInstance].accessToken;
    NSDictionary *param = @{@"access_token":token};
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlStr parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = responseObject;
        if ([responseDic isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArr = responseDic[@"data"];
            [weakSelf refreshTableView:dataArr];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)refreshTableView:(NSArray *)dataArr
{
    if (![dataArr isKindOfClass:[NSArray class]]) {
        dataArr = nil;
    }
    self.tableDataArr = dataArr;
    [_tabelView reloadData];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"pattinetcellaaa";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
//    NSDictionary *tempDic = _tableDataArr[indexPath.row];
//    cell.textLabel.text = tempDic[@"patientid"];
    cell.textLabel.text = [NSString stringWithFormat:@"____%ld",indexPath.row];
    
    return cell;
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
