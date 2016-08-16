//
//  IHF_NewSeriesSectionHeader.h
//  IHFMedicImage2.0
//
//  Created by ihefe_Hanrovey on 16/6/24.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *Series_New_HeaderID = @"Series_New_HeaderID";

@class IHF_NewSeriesSectionHeader,IHF_SeriesGroup;
@protocol IHF_NewSeriesSectionHeaderDelegate <NSObject>
@optional
- (void)headClickWithStu_id:(NSString *)stu_id studyInstanceUid:(NSString *)studyInstanceUid indexPath:(NSIndexPath *)indexPath;

@end


@interface IHF_NewSeriesSectionHeader : UICollectionReusableView

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) IHF_SeriesGroup *seriesGroup;
@property (nonatomic, weak, nullable) id <IHF_NewSeriesSectionHeaderDelegate> delegate;

+ (instancetype)headViewWithCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;
@end
