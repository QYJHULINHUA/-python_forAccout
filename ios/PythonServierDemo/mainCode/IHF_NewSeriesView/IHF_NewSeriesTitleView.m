//
//  IHF_NewSeriesTitleView.m
//  IHFMedicImage2.0
//
//  Created by ihefe_Hanrovey on 16/6/24.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import "IHF_NewSeriesTitleView.h"


@implementation IHF_NewSeriesTitleView
+ (instancetype)getIHF_NewSeriesTitleView
{
    IHF_NewSeriesTitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"IHF_NewSeriesTitleView" owner:self options:nil] firstObject];
    return titleView;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.cancel_Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
