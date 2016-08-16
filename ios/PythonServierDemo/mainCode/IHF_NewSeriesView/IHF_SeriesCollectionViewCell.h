//
//  IHF_SeriesCollectionViewCell.h
//  IHFMedicImage2.0
//
//  Created by Yoser on 12/22/15.
//  Copyright © 2015 ihefe_hlh. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *seriesCellID = @"SeriesCellID";
@class IHFMed_SeriesModel;

@interface IHF_SeriesCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IHFMed_SeriesModel *seriesModel;

+ (instancetype)getSeriesCollectionViewCellWith:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;

@end
