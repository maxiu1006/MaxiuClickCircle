//  RingMainCollectionViewCell.h
//  RingCharts
//
//  Created by xiaoxh on 2019/6/7.
//  Copyright © 2019 肖祥宏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingModel.h"

#define kRingMainCollectionViewCell @"RingMainCollectionViewCell"

NS_ASSUME_NONNULL_BEGIN

@interface RingMainCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)RingModel *model;
@end

NS_ASSUME_NONNULL_END
