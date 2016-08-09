//
//  IHFPatientListVC.h
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/2.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNEWIP @"http://192.168.10.20:9091/webserver-2.0"

@interface IHFPatientListVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (copy, nonatomic) NSArray *tableDataArr;

@end
