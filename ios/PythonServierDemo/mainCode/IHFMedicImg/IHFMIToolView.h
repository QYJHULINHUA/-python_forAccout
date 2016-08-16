//
//  IHFMIToolView.h
//  PythonServierDemo
//
//  Created by linhua hu on 16/8/15.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IHFToolDelegata <NSObject>

- (void)selectToolWithName:(NSString *)toolName;
- (void)selectToolColorWithIdx:(NSInteger)idx;

@end

@interface IHFMIToolView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic , strong)UICollectionView *collectionView;

@property (nonatomic , copy)NSArray *toolArr;

@property(nonatomic, weak)id<IHFToolDelegata> delegate;

@property (nonatomic ,assign)BOOL isColor;

@end
