//
//  IHF_NewSeriesView.m
//  IHFMedicImage2.0
//
//  Created by ihefe_Hanrovey on 16/6/24.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

/***************/
  //本类待优化,过于垃圾//
/***************/



#define EdgeInsets 15.f
#define Spacing 15.f


#import "IHF_NewSeriesView.h"
#import "IHF_NewSeriesTitleView.h"
#import "IHF_SeriesCollectionViewCell.h"
#import "IHF_NewSeriesSectionHeader.h"
#import "IHF_SeriesGroup.h"
#import "YX_Net.h"
#import "YX_ReqModel.h"
#import "IHFMed_SeriesModel.h"
@interface IHF_NewSeriesView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *seriesCollectionView;

@end

@implementation IHF_NewSeriesView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor blackColor];
        self.data = [NSMutableArray array];
        
        [self initUI:frame];
    
    }
    return self;
}

- (void)initUI:(CGRect)frame
{
    // 头部
    IHF_NewSeriesTitleView *titleView = [IHF_NewSeriesTitleView getIHF_NewSeriesTitleView];
    titleView.frame = CGRectMake(0, 0, frame.size.width, 54);
    [titleView addTarget:self action:@selector(dismissView)];
    [self addSubview:titleView];
    
    
    // 选择器
    UISegmentedControl *seriesSegment = [[UISegmentedControl alloc] initWithItems:@[@"当前患者",@"历史浏览"]];
    seriesSegment.tintColor = [UIColor colorWithRed:98.f/255.f green:167.f/255.f blue:217.f/255.f alpha:1];
    seriesSegment.selectedSegmentIndex = 0;
    seriesSegment.frame = CGRectMake(10.f, CGRectGetMaxY(titleView.frame) + 10, self.frame.size.width - 20.f, 30.f);
    seriesSegment.selectedSegmentIndex = 0;
    [seriesSegment  addTarget:self action:@selector(changSelectedItem:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:seriesSegment];

    
    // 序列UICollectionView
    CGFloat itemSizeW = (frame.size.width - EdgeInsets * 2 - Spacing * 2 ) / 3;
    CGFloat itemSizeH = itemSizeW / 19 * 24;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = Spacing;
    flowLayout.minimumLineSpacing = Spacing;
    flowLayout.itemSize = CGSizeMake(itemSizeW, itemSizeH);
    flowLayout.headerReferenceSize = CGSizeMake(frame.size.width, 30);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(3, 0, 0, 0);
    
    
    CGFloat collectionX = 0;
    CGFloat collectionY = CGRectGetMaxY(seriesSegment.frame) + 10;
    CGFloat collectionW = frame.size.width;
    CGFloat collectionH = frame.size.height - collectionY;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(collectionX, collectionY, collectionW, collectionH) collectionViewLayout:flowLayout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor colorWithRed:18.f/255.f green:18.f/255.f blue:18.f/255.f alpha:1];
    [self addSubview:collection];
    
    UINib *cellNib = [UINib nibWithNibName:@"IHF_SeriesCollectionViewCell" bundle:[NSBundle mainBundle]];
    [collection registerNib:cellNib forCellWithReuseIdentifier:seriesCellID];
    
    UINib *headerNib = [UINib nibWithNibName:@"IHF_NewSeriesSectionHeader" bundle:[NSBundle mainBundle]];
    [collection registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Series_New_HeaderID];
    
    _seriesCollectionView = collection;
}



//- (void)setP_Info:(IHF_PInfoModel *)p_Info
//{
//    _p_Info = p_Info;
//    [self requestStudyList_Current:p_Info.patientID];
//
//}

- (void)changSelectedItem:(UISegmentedControl *)segment
{
    NSInteger Index = segment.selectedSegmentIndex;
    switch (Index) {
            
        case 0:
        {
//            [self requestStudyList_Current:self.p_Info.patientID];
            break;
        }
            
        case 1:
        {
//            NSString *history_patientID = [IHFMAccountData getSingleInstancetype].seriesPinfo.patientID;
//            NSString *history_patientID;
//            [self requestStudyList_History:history_patientID];
            break;
        }
            
        default:
            break;
    }
}




#pragma mark - 请求序列信息
- (void)requestStudyList_History:(NSString *)patient_id
{
    __weak typeof(self) weakSelf = self;
    NSString *patientID;
//    = [NSString stringIsNull:patient_id];
//    [IHFNet_Ris getHistoryStudyListWithPatientId:patientID includingPACS:@"0" callBack:^(NSNumber *success, id response) {
//        
//        if (success.boolValue)
//        {
//            IHFNetRisModel *model = response;
//            NSParameterAssert(model);
//            NSArray *arr = model.data;
//            if (arr.count > 0)
//            {
//                NSMutableArray *tem = [NSMutableArray array];
//                for (NSDictionary *obj in arr)
//                {
//                    NSString *studyInstanceUid_Local = [IHFMAccountData getSingleInstancetype].seriesPinfo.relatetopacs;
//                    
//                    NSString *studyInstanceUid_Net = [NSString stringIsNull:obj[@"relatetopacs"]];
//                    
//                    if ([studyInstanceUid_Local isEqualToString:studyInstanceUid_Net])
//                    {
//                        @autoreleasepool {
//                            IHF_SeriesGroup *group = [[IHF_SeriesGroup alloc] initWithDic:obj];
//                            [tem addObject:group];
//                        }
//                    }
//                }
//                
//                weakSelf.data = tem;
//                
//            }else
//            {
//                [weakSelf.data removeAllObjects];
//                [KVNProgress showErrorWithStatus:@"无历史浏览数据!"];
//            }
//            
//        }else
//        {
//            IHFMNetErrorMsg *errorMsg = response;
//            NSParameterAssert(errorMsg);
//            [KVNProgress showErrorWithStatus:errorMsg.ErrorMsg];
//        }
//        
//        [weakSelf.seriesCollectionView reloadData];
//        
//    }];
    
}

- (void)requestStudyList_Current:(NSString *)patient_id
{
    __weak typeof(self) weakSelf = self;
    [YX_Net getRisList:[YX_ReqModel_login getShareInstance].accessToken callBack:^(NSNumber *success, id response) {
        if (success.boolValue)
        {
            
            NSDictionary *dic = response;
            NSArray *arr = dic[@"data"];

            if (arr.count > 0)
            {
                NSMutableArray *tem = [NSMutableArray array];
                for (NSDictionary *obj in arr)
                {
                    @autoreleasepool {
                        IHF_SeriesGroup *group = [[IHF_SeriesGroup alloc] initWithDic:obj];
                        
                        [tem addObject:group];
                    }
                }

                weakSelf.data = tem;
                [weakSelf.seriesCollectionView reloadData];

                [weakSelf firstSectionOfSelected];
            }
            
        }else
        {

        }

    }];

}

- (void)firstSectionOfSelected
{
    if (self.data.count <= 0)
    {
        return;
    }
    
    
    for (int i = 0; i < self.data.count; i++)
    {
        IHF_SeriesGroup *group = self.data[i];
        
        __weak typeof(self) weakSelf = self;
        [YX_Net getImageSeriesListWithStudyID:group.stu_id RelateID:group.relatetopacs callBack:^(NSNumber *success, id response) {
            if (success.boolValue)
            {
                NSDictionary *dic = response;
                NSArray *arr = dic[@"data"];
                if (arr.count > 0)
                {
                    NSMutableArray *tem = [NSMutableArray array];
                    for (NSDictionary *obj in arr)
                    {
                        @autoreleasepool { //自动回收临时变量
                            IHFMed_SeriesModel *model = [[IHFMed_SeriesModel alloc] init];
                            model.modality = obj[@"modality"];
                            model.imagenum = obj[@"imagenum"];
                            model.seriestime = obj[@"seriestime"];
                            model.seriesId = obj[@"seriesId"];// 缩略图
                            model.seriesinstanceuid = obj[@"seriesinstanceuid"];
                            model.imageindex = obj[@"imageindex"];
                            model.seriesdesc = obj[@"seriesdesc"];
                            model.seriesno = obj[@"seriesno"];
                            model.seriesDic = obj;
                            [tem addObject:model];
                        }
                    }
                    
                    IHF_SeriesGroup *group = weakSelf.data[i];
                    group.seriess = tem;
                    
                }
            }
        }];
    }
}

- (void)dismissView
{
    [self removeFromSuperview];
}

#pragma mark DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    IHF_SeriesGroup *group = _data[section];
    NSInteger count = group.opened ? group.seriess.count : 0;
    return count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        IHF_NewSeriesSectionHeader *header = [IHF_NewSeriesSectionHeader headViewWithCollectionView:collectionView IndexPath:indexPath];
        header.delegate = self;
        
        IHF_SeriesGroup *group = _data[indexPath.section];
        header.seriesGroup = group;
        header.indexPath = indexPath;
        
//        if ([self.p_Info.relatetopacs isEqualToString:group.relatetopacs])
//        {
////           header.backgroundColor = [UIColor colorWithRed:87.f/255.f green:157.f/255.f blue:170.f/255.f alpha:1];
//           header.alpha = 0.5;
//            
//        }else
//        {
//            header.backgroundColor = [UIColor darkGrayColor];
//            header.alpha = 0.8;
//        }
        
        return header;
    }else
    {
        return nil;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IHF_SeriesCollectionViewCell *cell = [IHF_SeriesCollectionViewCell getSeriesCollectionViewCellWith:collectionView IndexPath:indexPath];
    
    IHF_SeriesGroup *group = _data[indexPath.section];
    IHFMed_SeriesModel *model = group.seriess[indexPath.row];
    cell.seriesModel = model;

    return cell;
}

#pragma mark - Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if([self.delegate respondsToSelector:@selector(SeriesViewSelectedIndex:Series:)])
    {
        
        
        IHF_SeriesGroup *group = _data[indexPath.section];
        IHFMed_SeriesModel *model = group.seriess[indexPath.row];
        IHFPatientModel *modell = [[IHFPatientModel alloc] init];
        modell.stuDic = group.stdDic;
        modell.seriesDic = model.seriesDic;
        [self.delegate SeriesViewSelectedIndex:indexPath Series:modell];
        
    }

}

#pragma mark - IHF_NewSeriesSectionHeaderDelegate
- (void)headClickWithStu_id:(NSString *)stu_id studyInstanceUid:(NSString *)studyInstanceUid indexPath:(NSIndexPath *)indexPath
{
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
    [self.seriesCollectionView reloadSections:indexSet];

}
@end
