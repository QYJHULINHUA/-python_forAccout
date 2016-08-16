//
//  IHF_NewSeriesView.h
//  IHFMedicImage2.0
//
//  Created by ihefe_Hanrovey on 16/6/24.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHFMed_SeriesModel.h"
#import "IHFPatientModel.h"

@protocol IHF_NewSeriesViewDelegate <NSObject>
- (void)SeriesViewSelectedIndex:(NSIndexPath *)indexPath Series:(IHFPatientModel *)seriesModel;
@end

@interface IHF_NewSeriesView : UIView

@property (strong, nonatomic) NSMutableArray *data;


@property (weak, nonatomic) id<IHF_NewSeriesViewDelegate>delegate;

- (void)requestStudyList_Current:(NSString *)patient_id;


@end
