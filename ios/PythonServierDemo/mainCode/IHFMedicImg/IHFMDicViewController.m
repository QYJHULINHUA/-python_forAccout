//
//  IHFMDicViewController.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/15.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFMDicViewController.h"
#import "AppDelegate.h"
#import "IHFIMGView.h"
#import "IHFMIToolView.h"
#import "IHFSharpenView.h"
@interface IHFMDicViewController ()<IHFToolDelegata,IHFSharpenViewDelegate>
{
    IHFIMGView *medicImgView;
    IHFMIToolView *toolView;
    UISlider *sildeView;
    
}

@end

@implementation IHFMDicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [self initView];
}

- (void)initView
{
    CGFloat w = [UIScreen mainScreen].bounds.size.height;
    medicImgView = [[IHFIMGView alloc] initWithFrame:CGRectMake(150, 0, w, w)];
    medicImgView.medicImgVC = self;
    [self.view addSubview:medicImgView];
    
    UIButton *escButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [escButton addTarget:self action:@selector(escViewController) forControlEvents:UIControlEventTouchUpInside];
    [escButton setImage:[UIImage imageNamed:@"esc-1"] forState:normal];
    [self.view addSubview:escButton];
    
    
    sildeView = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, w - 90, 30)];
    sildeView.transform = CGAffineTransformRotate(sildeView.transform, M_PI_2);
    [sildeView addTarget:self action:@selector(sildeViewChange:) forControlEvents:UIControlEventValueChanged];
    sildeView.center = CGPointMake(25, 0.5 * w + 30);
    [self.view addSubview:sildeView];
    medicImgView.slider = sildeView;
    
    
    toolView = [[IHFMIToolView alloc] initWithFrame:CGRectMake(170 + w, 0, [UIScreen mainScreen].bounds.size.width - w - 180, w)];
    toolView.delegate = self;
    [self.view addSubview:toolView];
}

- (void)escViewController
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)setPatientModelF:(IHFPatientModel *)patientMoel
{
    [medicImgView configPatientModel:patientMoel];
}

- (void)sildeViewChange:(UISlider *)slieder
{
    [medicImgView reqImg:slieder.value];
}

- (void)selectToolWithName:(NSString *)toolName
{
   if ([toolName isEqualToString:@"锐化"])
    {
        
        IHFSharpenView *_sharpenView = [[IHFSharpenView alloc] initWithFrame:CGRectMake(0, 70, 300, 100)];
        _sharpenView.delegate = self;
        [self.view addSubview:_sharpenView];
    }else
    {
        [medicImgView controllerMedicImageViewWithTool:toolName];
    }
    
}

- (void)selectToolColorWithIdx:(NSInteger)idx
{
    [medicImgView setColorWithIDx:idx - 1];
}

- (void)SharpenViewChangeValue:(CGFloat)value
{
    [medicImgView setSharpenValue:value / 50.f];
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
