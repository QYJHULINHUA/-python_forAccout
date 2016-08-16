//
//  IHFMIToolView.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/15.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "IHFMIToolView.h"
#define EdgeInsets 15.f
#define Spacing 15.f
#import "IHFToolCollectionViewCell.h"

static NSString *const cellId = @"ihftoolcellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@implementation IHFMIToolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _toolArr = @[@"重置未选中",@"伪彩未选中",@"向左旋转",@"向右旋转",@"水平镜像",@"垂直镜像",@"锐化",@"定位线未选中"];
        _isColor = NO;
        [self loadCollectionView:frame];
    }
    return self;
}

- (void)loadCollectionView:(CGRect)frame
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = Spacing;
    flowLayout.minimumLineSpacing = Spacing;
    flowLayout.itemSize = CGSizeMake(50, 50);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    
    // 注册cell、sectionHeader、sectionFooter
    UINib *nib = [UINib nibWithNibName:@"IHFToolCollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellId];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_isColor) {
        return 15;
        
    }else
    {
        return _toolArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IHFToolCollectionViewCell *cell = (IHFToolCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (_isColor) {
        if (indexPath.row == 0) {
            cell.img.backgroundColor = [self getColorWithIdx:0];
            cell.img.image = [UIImage imageNamed:@"返回"];
        }else
        {
            cell.img.image = nil;
            cell.img.backgroundColor = [self getColorWithIdx:indexPath.row];
        }
        
    }else
    {
        cell.img.backgroundColor = [UIColor clearColor];
        NSString *imgStr = _toolArr[indexPath.row];
        cell.img.image = [UIImage imageNamed:imgStr];
    }
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isColor) {
        if (indexPath.row == 0) {
            _isColor = NO;
            _collectionView.backgroundColor = [UIColor blackColor];
            [collectionView reloadData];
        }else
        {
            if ([self.delegate respondsToSelector:@selector(selectToolColorWithIdx:)]) {
                [self.delegate selectToolColorWithIdx:indexPath.row];
            }

        }
        
    }else
    {
        NSString *str = _toolArr[indexPath.row];
        if ([str isEqualToString:@"伪彩未选中"]) {
            _isColor = YES;
            _collectionView.backgroundColor = [UIColor grayColor];
            [collectionView reloadData];
            
        }else
        {
            if ([self.delegate respondsToSelector:@selector(selectToolWithName:)]) {
                [self.delegate selectToolWithName:str];
            }
        }
        
    }
    
}

- (UIColor *)getColorWithIdx:(NSInteger)idx
{
    switch (idx) {
        case 1:
            return [UIColor blackColor];
            break;
            
        case 2:
            return [UIColor colorWithRed:220.0f / 255.0f green: 222.0f / 255.0f blue:224.0f / 255.0f alpha:1.0f];
            break;
            
        case 3:
            return [UIColor colorWithRed:166.0f / 255.0f green:170.0f / 255.0f blue:168.0f / 255.0f alpha:1.0f];
            break;
            
        case 4:
            return [UIColor colorWithRed:212.0f / 255.0f green:89.0f / 255.0f blue:84.0f / 255.0f alpha:1.0f];
            break;
            
        case 5:
            return [UIColor colorWithRed:123.0f / 255.0f green:219.0f / 255.0f blue:69.0f / 255.0f alpha:1.0f];
            break;
            
        case 6:
            return [UIColor colorWithRed:20.0f / 255.0f green:151.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
            break;
            
        case 7:
            return [UIColor colorWithRed:232.0f / 255.0f green:164.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f];
            break;
            
        case 8:
            return [UIColor colorWithRed:0.0f green:166.0f / 255.0f blue:172.0f / 255.0f alpha:1.0f];
            break;
            
        case 9:
            return [UIColor colorWithRed:157.0f / 255.0f green:69.0f / 255.0f blue:184.0f / 255.0f alpha:1.0f];
            break;
            
        case 10:
            return [UIColor colorWithRed:0.0f green:113.0f / 255.0f blue:216.0f / 255.0f alpha:1.0f];
            break;
            
        case 11:
            return  [self cololr10];
            break;
            
        case 12:
            return [self cololr11];
            break;
            
        case 13:
            return [self cololr12];
            break;
            
        case 14:
            return [self cololr13];
            break;
            
        case 15:
            return [self cololr14];
            break;
            
            
        default:
            return nil;
            break;
    }
}

- (UIColor*)cololr10
{
    UIImage *img = [UIImage imageNamed:@"wcc1"];
    
    return [UIColor colorWithPatternImage:img];
}

- (UIColor*)cololr11
{
    UIImage *image2 = [UIImage imageNamed:@"wcc2"];
    return [UIColor colorWithPatternImage:image2];
}
- (UIColor*)cololr12
{
    UIImage *image3 = [UIImage imageNamed:@"wcc3"];
    return [UIColor colorWithPatternImage:image3];
}

- (UIColor*)cololr13
{
    UIImage *image3 = [UIImage imageNamed:@"wcc4"];
    return [UIColor colorWithPatternImage:image3];
}

- (UIColor*)cololr14
{
    UIImage *image3 = [UIImage imageNamed:@"wcc5"];
    return [UIColor colorWithPatternImage:image3];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
