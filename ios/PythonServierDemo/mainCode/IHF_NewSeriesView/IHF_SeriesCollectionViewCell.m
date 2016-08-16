//
//  IHF_SeriesCollectionViewCell.m
//  IHFMedicImage2.0
//
//  Created by Yoser on 12/22/15.
//  Copyright © 2015 ihefe_hlh. All rights reserved.
//

#import "IHF_SeriesCollectionViewCell.h"
#import "IHFMed_SeriesModel.h"
#import "NSString+XH.h"
#import "UIImageView+WebCache.h"
#import "YX_ReqModel.h"
@interface IHF_SeriesCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *seriesModalityLab;

@property (weak, nonatomic) IBOutlet UILabel *seriesNumberLab;

@property (weak, nonatomic) IBOutlet UILabel *seriesDateLab;

@property (weak, nonatomic) IBOutlet UIImageView *seriesSmallImage;

@end

@implementation IHF_SeriesCollectionViewCell

+ (instancetype)getSeriesCollectionViewCellWith:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath
{
    IHF_SeriesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:seriesCellID forIndexPath:indexPath];
    return cell;
}

- (void)setSeriesModel:(IHFMed_SeriesModel *)seriesModel
{
    _seriesModel = seriesModel;
    
    _seriesDateLab.text = [NSString respellSeriesTime:seriesModel.seriestime];
    
    _seriesModalityLab.text = [NSString stringIsNull:seriesModel.modality];
    
    _seriesNumberLab.text = [NSString stringIsNull:seriesModel.imagenum.stringValue];

    // 缩略图
    NSString *token = [YX_ReqModel_login  getShareInstance].accessToken;
    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.10.20:9091/webserver-2.0/image/getSeriesThumbnail?access_token=%@&seriesid=%@",token,seriesModel.seriesId];
    [_seriesSmallImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"IHE_Series_Palcehold"]];
}

/*!
 *  @author 呼噜娃, 16-05-03 09:05:54
 *
 *  @brief 该方法主要是为了因为离线下载没有缩略图，从而取得离线文件中的缩略图
 *
 *  @param model seriresModel 数据模型
 *
 *  @return IHF_SeriesModel中的smallImage
 */
//- (UIImage *)getSmallImg:(IHF_SeriesModel*)model
//{
//    if (model.smallImage) {
//        
//    }else
//    {
//        NSString * _offLinePath = [IHFMCommonTools creatDocDicAddFilePath:[NSString stringWithFormat:@"%@/%@/%@/%@/%@/thumbnail.jpeg",IHFOffLineDownLoadFilePath,model.patientID,model.studyID,model.serierID,model.serierID]];
//        model.smallImage = [UIImage imageWithContentsOfFile:_offLinePath];
//    }
//    
//    return model.smallImage;
//    
//}



@end
