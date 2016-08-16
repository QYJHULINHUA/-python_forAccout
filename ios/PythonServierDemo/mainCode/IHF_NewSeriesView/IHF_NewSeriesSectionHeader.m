//
//  IHF_NewSeriesSectionHeader.m
//  IHFMedicImage2.0
//
//  Created by ihefe_Hanrovey on 16/6/24.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import "IHF_NewSeriesSectionHeader.h"
#import "IHF_SeriesGroup.h"
@interface IHF_NewSeriesSectionHeader()
@property (weak, nonatomic) IBOutlet UIImageView *arrow_ImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateTime_Lab;
@property (weak, nonatomic) IBOutlet UILabel *modality_Lab;
@property (weak, nonatomic) IBOutlet UILabel *part_Lab;
@property (weak, nonatomic) IBOutlet UIButton *click_Btn;

@end

@implementation IHF_NewSeriesSectionHeader
+ (instancetype)headViewWithCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;
{
    IHF_NewSeriesSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Series_New_HeaderID forIndexPath:indexPath];
    return header;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
#warning 禁止默认的拉伸现象
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

- (IBAction)btn_Click:(UIButton *)sender
{
    _seriesGroup.opened = !_seriesGroup.isOpened;
    
    _arrow_ImageView.image = _seriesGroup.isOpened ? [UIImage imageNamed:@"IHF_NewSeriesHead_Arrow_Down"] : [UIImage imageNamed:@"IHF_NewSeriesHead_Arrow_Right"];

    if ([self.delegate respondsToSelector:@selector(headClickWithStu_id:studyInstanceUid:indexPath:)]) {
         [self.delegate headClickWithStu_id:self.seriesGroup.stu_id studyInstanceUid:self.seriesGroup.studyInstanceUid indexPath:self.indexPath];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}

- (void)setSeriesGroup:(IHF_SeriesGroup *)seriesGroup
{
    _seriesGroup = seriesGroup;
    
//    self.dateTime_Lab.text = [NSString respellStudydate:seriesGroup.dateTime];
    self.modality_Lab.text = seriesGroup.modality;
    self.part_Lab.text = seriesGroup.part;
    
    _arrow_ImageView.image = _seriesGroup.isOpened ? [UIImage imageNamed:@"IHF_NewSeriesHead_Arrow_Down"] : [UIImage imageNamed:@"IHF_NewSeriesHead_Arrow_Right"];
}

- (void)didMoveToSuperview
{
    self.arrow_ImageView.image = _seriesGroup.opened ? [UIImage imageNamed:@"IHF_NewSeriesHead_Arrow_Down"] : [UIImage imageNamed:@"IHF_NewSeriesHead_Arrow_Right"];
}
@end
