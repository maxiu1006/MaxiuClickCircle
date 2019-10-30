//
//  RingBottomCollectionViewCell.h
//  RingCharts
//
//  Created by xiaoxh on 2019/6/7.
//  Copyright © 2019 肖祥宏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingModel.h"

#define kRingBottomCollectionViewCell @"RingBottomCollectionViewCell"
NS_ASSUME_NONNULL_BEGIN

@interface RingBottomCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (nonatomic,strong)DataListModel *listModel;
@end

NS_ASSUME_NONNULL_END
