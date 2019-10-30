//
//  YDCircleProgressView.m
//  ModuleReport
//
//  Created by xiaoxh on 2019/10/30.
//  Copyright © 2019 yidayuntu. All rights reserved.
//

#import "YDCircleProgressView.h"

@interface YDCircleProgressView ()
/** 原点 */
@property (nonatomic, assign) CGPoint origin;
/** 半径 */
@property (nonatomic, assign) CGFloat radius;
/** 起始 */
@property (nonatomic, assign) CGFloat startAngle;
/** 结束 */
@property (nonatomic, assign) CGFloat endAngle;
/** CAShapeLayer边数组 */
@property (nonatomic, strong) NSMutableArray *beziPathArray;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *resArray;
/** 圆环颜色数组 */
@property (nonatomic, strong) NSMutableArray <UIColor*>*colorArray;
/** 圆环间隙 */
@property (nonatomic, assign) CGFloat interval;
/** 选中圆环的下标 */
@property (nonatomic, assign) NSInteger selectIndex;
@end
@implementation YDCircleProgressView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame progress:(CGFloat)progress {
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
        [self setInitialValue];
    }
    return self;
}

#pragma mark - 加载UI
- (void)setUI {
    [self addSubview:self.topTipLabel];
    [self addSubview:self.bottomTipLabel];
}

#pragma mark - 设置初始值
- (void)setInitialValue
{
    self.origin = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.radius = self.bounds.size.width / 2;
    self.interval = M_PI*0.01;
    self.startAngle = M_PI*3/2+self.interval;
    self.selectIndex = -1;
}

#pragma mark - 清除CAShapeLayer
- (void)clear{
    if(self.beziPathArray.count){
        for (CAShapeLayer *layal  in self.beziPathArray) {
            [layal removeFromSuperlayer];
        }
    }
    [self setNeedsDisplay];
}

#pragma mark - 画圆环
- (void)loadCircleArr:(NSArray*)resArray colrrArr:(NSArray<UIColor *>*)colorArr
{
    self.resArray = resArray.copy;
    self.colorArray = colorArr.copy;
    [self loadCircleShapeLayerIndex:self.selectIndex];
}
- (void)loadCircleShapeLayerIndex:(NSInteger)index{
    for (NSInteger i = 0; i<self.resArray.count; i++) {
        self.endAngle = self.startAngle + [self.resArray[i] doubleValue] * (M_PI * 2-(self.interval*self.resArray.count));
        if (i == index) {
            [self innerShadowIndex:index];
            [self outsideShadowIndex:index];
            [self centerShapeLayerIndex:index isSelect:YES];
        }else{
            [self centerShapeLayerIndex:i isSelect:NO];
        }
        self.startAngle = self.endAngle+self.interval;
    }
}
#pragma mark - 选择状态
- (void)selectParagraphIndex:(NSInteger)index{
    self.selectIndex = index;
    [self loadCircleShapeLayerIndex:index];
}

#pragma mark - setMethod
- (void)setProgressWidth:(CGFloat)progressWidth {
    _progressWidth = progressWidth;
}

#pragma mark - 画中间圆环CAShapeLayer
- (void)centerShapeLayerIndex:(NSInteger)index isSelect:(BOOL)isSelect{
    CAShapeLayer *topLayer = [CAShapeLayer layer];
    topLayer.fillColor = [UIColor clearColor].CGColor;
    topLayer.strokeColor = self.colorArray[index].CGColor;;
    UIBezierPath *topPath = [UIBezierPath bezierPathWithArcCenter:_origin radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    topLayer.path = topPath.CGPath;
    if (isSelect) {
        topLayer.lineWidth = self.progressWidth+1.5;
    }else{
        topLayer.lineWidth = self.progressWidth;
    }
    [self.layer addSublayer:topLayer];
    [self.beziPathArray addObject:topLayer];
}

#pragma mark - 画内阴影CAShapeLayer
- (void)innerShadowIndex:(NSInteger)index{
    CAShapeLayer *intLayer = [CAShapeLayer layer];
    intLayer.fillColor = [UIColor clearColor].CGColor;
    UIBezierPath *intPath = [UIBezierPath bezierPathWithArcCenter:self.origin radius:self.radius-self.progressWidth/2-3 startAngle:self.startAngle-self.interval endAngle:self.endAngle+self.interval clockwise:YES];
    intLayer.path = intPath.CGPath;
    intLayer.strokeColor = [UIColor whiteColor].CGColor;
    intLayer.lineWidth = 6;
    intLayer.shadowOffset = CGSizeMake(0, 8);
    intLayer.shadowRadius = 10;
    intLayer.shadowColor = self.colorArray[index].CGColor;
    intLayer.shadowOpacity = 0.9;
    [self.layer addSublayer:intLayer];
    [self.beziPathArray addObject:intLayer];
}

#pragma mark - 画外阴影CAShapeLayer
- (void)outsideShadowIndex:(NSInteger)index{
    CAShapeLayer *outerLayer = [CAShapeLayer layer];
    outerLayer.fillColor = [UIColor clearColor].CGColor;
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithArcCenter:self.origin radius:self.radius+self.progressWidth/2+3 startAngle:self.startAngle-self.interval endAngle:self.endAngle+self.interval clockwise:YES];
    outerLayer.path = outerPath.CGPath;
    outerLayer.lineWidth = 6;
    outerLayer.shadowOffset = CGSizeMake(0, 8);
    outerLayer.shadowColor = self.colorArray[index].CGColor;
    outerLayer.shadowOpacity = 0.9;
    outerLayer.shadowRadius = 10;
    outerLayer.strokeColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:outerLayer];
    [self.beziPathArray addObject:outerLayer];
}
#pragma mark - 懒加载
- (UILabel *)topTipLabel {
    if (!_topTipLabel) {
        _topTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 17)];
        _topTipLabel.center = CGPointMake(self.bounds.size.width / 2 , self.bounds.size.height / 2 -12);
        _topTipLabel.textAlignment = NSTextAlignmentCenter;
        _topTipLabel.font = [UIFont systemFontOfSize:12];
        _topTipLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _topTipLabel;
}

- (UILabel *)bottomTipLabel {
    if (!_bottomTipLabel) {
        _bottomTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 17)];
        _bottomTipLabel.center = CGPointMake(self.bounds.size.width / 2 , self.bounds.size.height / 2 + 12);
        _bottomTipLabel.textAlignment = NSTextAlignmentCenter;
        _bottomTipLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    }
    return _bottomTipLabel;
}

- (NSMutableArray *)beziPathArray
{
    if (!_beziPathArray) {
        _beziPathArray = [[NSMutableArray alloc] init];
    }
    return _beziPathArray;
}

- (NSMutableArray *)resArray{
    if (!_resArray) {
        _resArray = [[NSMutableArray alloc] init];
    }
    return _resArray;
}

- (NSMutableArray<UIColor *> *)colorArray{
    if (!_colorArray) {
        _colorArray = [[NSMutableArray alloc] init];
    }
    return _colorArray;
}
@end
#pragma mark - 画圆环之间间隔，先注视用另一种方法
//double mun = 0.0;
//for (NSInteger i = 0; i<resArray.count; i++) {
//    //设置路径画布
//    CAShapeLayer *topLineLayer = [CAShapeLayer layer];
//    topLineLayer.lineWidth = 4.0;
//    topLineLayer.strokeColor = [UIColor clearColor].CGColor; //   边线颜色
//    topLineLayer.fillColor  = nil;
//    if ([model.percent doubleValue]) {
//        double du = [model.percent doubleValue];
//        topLineLayer.path = [self getEndPointFrameWithProgress:(M_PI * 2-(interval*resArray.count))*mun percentage:[model.percent doubleValue]].CGPath;
//        [self.layer addSublayer:topLineLayer];
//        mun = mun + du;
//    }
//}
//-(UIBezierPath*)getEndPointFrameWithProgress:(float)angle percentage:(CGFloat)percentage
//{
//    UIBezierPath *linePath = [UIBezierPath bezierPath];
//    float radius = self.radius;//半径
//    int index = (angle)/M_PI_2;//用户区分在第几象限内
//    float needAngle = angle - index*M_PI_2;//用于计算正弦/余弦的角度
//    float x = 0,y = 0,x1 = 0,y1 = 0;//用于保存_dotView的frame
//    switch (index) {
//        case 0:
//            //NSLog(@"第一象限");
//            x = radius + sinf(needAngle)*(radius-self.progressWidth/2-4);
//            y = radius - cosf(needAngle)*(radius-self.progressWidth/2-4);
//            x1 = x + sinf(needAngle)*(self.progressWidth+8);
//            y1 = y - cosf(needAngle)*(self.progressWidth+8);
//            break;
//        case 1:
//            //NSLog(@"第二象限");
//            x = radius + cosf(needAngle)*(radius-self.progressWidth/2-4);
//            y = radius + sinf(needAngle)*(radius-self.progressWidth/2-4);
//            x1 = x + cosf(needAngle)*(self.progressWidth+8);
//            y1 = y + sinf(needAngle)*(self.progressWidth+8);
//            break;
//        case 2:
//            //NSLog(@"第三象限");
//            x = radius - sinf(needAngle)*(radius-self.progressWidth/2-4);
//            y = radius + cosf(needAngle)*(radius-self.progressWidth/2-4);
//            x1 = x - sinf(needAngle)*(self.progressWidth+8);
//            y1 = y + cosf(needAngle)*(self.progressWidth+8);
//            break;
//        case 3:
//            //NSLog(@"第四象限");
//            x = radius - cosf(needAngle)*(radius-self.progressWidth/2-4);
//            y = radius - sinf(needAngle)*(radius-self.progressWidth/2-4);
//            x1 = x - cosf(needAngle)*(self.progressWidth+8);
//            y1 = y - sinf(needAngle)*(self.progressWidth+8);
//            break;
//        default:
//            break;
//    }
//    CGPoint startPoint = CGPointMake(x, y);
//    CGPoint endPoint = CGPointMake(x1, y1);
//    [linePath moveToPoint:startPoint];
//    [linePath addLineToPoint:endPoint];
//    return  linePath;
//}



