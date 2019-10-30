//
//  RingMainCollectionViewCell.m
//  RingCharts
//
//  Created by xiaoxh on 2019/6/7.
//  Copyright © 2019 肖祥宏. All rights reserved.
//

#import "RingMainCollectionViewCell.h"
#import "YDCircleProgressView.h"
#import "RingBottomCollectionViewCell.h"
#import "AppMacro.h"
#define kScreenWidth kScreenBounds.size.width
#define kScreenHeight kScreenBounds.size.height

@interface RingMainCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *upperLeftView;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLb;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *nodataLb;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong)YDCircleProgressView *circleProgress;//圆环
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property (nonatomic,assign)NSInteger index;
@end
@implementation RingMainCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.index = -1;
    self.upperLeftView.backgroundColor = kCorlorFromHexcode(0xf4bb40);
    self.topTitleLb.textColor = kCorlorFromHexcode(0x999999);;
    self.topTitleLb.font = [UIFont systemFontOfSize:16];
    self.nodataLb.text = @"暂无数据";
    self.nodataLb.textColor = kCorlorFromHexcode(0x4f45e2);;
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumLineSpacing = 0;//横向间距
    self.layout.minimumInteritemSpacing = 0;//纵向间距
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.collectionViewLayout = self.layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RingBottomCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kRingBottomCollectionViewCell];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}
-(void)setModel:(RingModel *)model
{
    _model = model;
    
    self.circleProgress.topTipLabel.text = model.topTip;
    self.circleProgress.bottomTipLabel.text = @"12月";
    //比例
    self.topTitleLb.text = model.topTip;
    if (model.dataList.count == 0) {
        self.collectionView.hidden = YES;
        self.circleView.hidden = YES;
        self.nodataLb.hidden = NO;
    }else{
        self.collectionView.hidden = NO;
        self.circleView.hidden = NO;
        self.nodataLb.hidden = YES;
        [self.circleView addSubview:self.circleProgress];
        [self.circleProgress clear];
        NSMutableArray *percentArray = [[NSMutableArray alloc] init];
        for (DataListModel *dataModel in model.dataList) {
            [percentArray addObject:dataModel.percent];
        }
        [self.circleProgress loadCircleArr:percentArray colrrArr:model.colorsArray];
    }
    self.layout.itemSize = CGSizeMake((kScreenWidth-20)/3, 70);
    [self.collectionView reloadData];
}
-(YDCircleProgressView *)circleProgress
{
    if(!_circleProgress){
        _circleProgress = [[YDCircleProgressView alloc] initWithFrame:self.circleView.bounds progress:0];
        _circleProgress.progressWidth = 12;
        _circleProgress.topTipLabel.textColor = kCorlorFromHexcode(0x333333);
        _circleProgress.bottomTipLabel.textColor = kCorlorFromHexcode(0x333333);
    }
    return _circleProgress;
}
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.dataList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RingBottomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRingBottomCollectionViewCell forIndexPath:indexPath];
    if (indexPath.row == self.index) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (self.model.dataList.count > indexPath.item) {
        [cell setListModel:self.model.dataList[indexPath.item]];
    }
    if (self.model.colorsArray.count > indexPath.item) {
        cell.leftView.backgroundColor = self.model.colorsArray[indexPath.item];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.circleProgress clear];
    self.circleProgress.topTipLabel.text = [self.model.dataList[indexPath.row] XName];
    self.circleProgress.bottomTipLabel.text = [self.model.dataList[indexPath.row] count];
    [self.circleProgress selectParagraphIndex:indexPath.row];
    self.index = indexPath.row;
    [self.collectionView reloadData];
}
@end
