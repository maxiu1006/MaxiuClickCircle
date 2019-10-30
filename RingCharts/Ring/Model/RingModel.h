//
//  RingModel.h
//  RingCharts
//
//  Created by xiaoxh on 2019/6/7.
//  Copyright © 2019 肖祥宏. All rights reserved.
//

#import "JSONModel.h"

@interface DataListModel : NSObject
/*名称*/
@property (nonatomic,copy)NSString *XName;
/*数量，金额*/
@property (nonatomic,copy)NSString *count;
/*占比*/
@property (nonatomic,copy)NSString *percent;

@end

@protocol DataListModel
@end

@interface RingModel : JSONModel
/*饼图数据*/
@property (nonatomic,strong)NSArray <DataListModel *>* dataList;
/*饼图高度*/
@property (nonatomic,assign)NSInteger pieHight;
/*饼图颜色数组*/
@property (nonatomic,strong)NSArray *colorsArray;
@property (nonatomic,copy)NSString *topTip;
@end




