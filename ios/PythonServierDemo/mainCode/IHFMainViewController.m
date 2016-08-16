//
//  IHFMainViewController.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/15.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFMainViewController.h"
#import "IHZMessageCell.h"
#import "IHFMedicImgViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface IHFMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_mainTableView;
    
}

@end

@implementation IHFMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainTableView = [[UITableView alloc] init];
    _mainTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _mainTableView.delegate = self;
    _mainTableView.dataSource =self;
    _mainTableView.rowHeight = 75.f;
    [self.view addSubview:_mainTableView];
    
//    UIView *headView = [[UIView alloc] init];
//    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//    _mainTableView.tableHeaderView = headView;
//    
//    _searchBtn = [[UILabel alloc] init];
//    _searchBtn.frame = CGRectMake(0, 0, 90, 29);
//    _searchBtn.center = CGPointMake(headView.frame.size.width/2, headView.frame.size.height/2);
//    _searchBtn.text = @"功能列表";
//    [headView addSubview:_searchBtn];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"功能列表";
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - tableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier_c = @"IHZMessageCell";
    IHZMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_c];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IHZMessageCell" owner:nil options:nil] objectAtIndex:0];
        [cell zcl_prepare];
    }
    NSInteger idx = indexPath.row + 1;
    cell.tagLabel.text = [NSString stringWithFormat:@"%ld",idx];
    
    if (idx == 3) {
        cell.nameLabel.text = @"数字影像";
        cell.nameLabel.textColor = [UIColor greenColor];
    }
    else
    {
        cell.nameLabel.text = [NSString stringWithFormat:@"功能%ld",idx];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        IHFMedicImgViewController *medicImgVc = [[IHFMedicImgViewController alloc] init];
        [self.navigationController pushViewController:medicImgVc animated:YES];
    }
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
