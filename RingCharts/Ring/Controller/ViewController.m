//
//  ViewController.m
//  RingCharts
//
//  Created by xiaoxh on 2019/6/7.
//  Copyright © 2019 肖祥宏. All rights reserved.
//

#import "ViewController.h"
#import "RingModel.h"
#import "AppMacro.h"
#import "RingMainCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionview;
@property (nonatomic,strong)NSMutableArray *dataArray;//总数据源
@property (nonatomic,assign)CGFloat pieHight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pieHight = 300;
    [self.view addSubview:self.collectionview];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *arr ;
    NSArray *arr1 ;
    NSArray *arr2 ;
    RingModel *reModel = [[ RingModel alloc] init];
    reModel.topTip = @"学生运动爱好";
    arr = @[@"乒乓球",@"篮球",@"羽毛球",@"足球",@"排球",@"五子棋",@"象棋",@"游泳",@"网球"];
    arr1 = @[@"50",@"15",@"7",@"40",@"23",@"12",@"8",@"40",@"5"];
    arr2 = @[@"0.25",@"0.075",@"0.035",@"0.2",@"0.115",@"0.06",@"0.04",@"0.2",@"0.025"];
    for (NSInteger i=0; i<arr.count; i++) {
        DataListModel *model = [[DataListModel alloc] init];
        model.XName =arr[i];
        model.count =arr1[i];
        model.percent = arr2[i];
        [array addObject:model];
    }
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:kCorlorFromHexcode(0x2B5AE7)];
    [colors addObject:kCorlorFromHexcode(0x3ca0fe)];
    [colors addObject:kCorlorFromHexcode(0x2BBDE7)];
    [colors addObject:kCorlorFromHexcode(0x2FFFF5)];
    [colors addObject:kCorlorFromHexcode(0x9868D2)];
    [colors addObject:kCorlorFromHexcode(0x4FC972)];
    [colors addObject:kCorlorFromHexcode(0x966A2C)];
    reModel.dataList = array.mutableCopy;
    //大于10个默认颜色，之后加随机颜色
    if (reModel.dataList.count > colors.count) {
        for (NSInteger i=colors.count; i<array.count; i++) {
            [colors addObject:[UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1]];
        }
    }
    reModel.colorsArray = colors.mutableCopy;
    reModel.pieHight = self.pieHight + (reModel.dataList.count % 3 > 0 ?reModel.dataList.count/3 + 1: reModel.dataList.count/3)*70;
    [self.dataArray addObject:reModel];
    [self.collectionview reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    RingMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRingMainCollectionViewCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[RingMainCollectionViewCell alloc] init];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (self.dataArray.count > indexPath.section) {
        [cell setModel:self.dataArray[indexPath.section]];
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.dataArray.count > indexPath.section) {
        RingModel *reModel = self.dataArray[indexPath.section];
        return CGSizeMake(kScreenWidth-20, reModel.pieHight);
    }
    return CGSizeMake(kScreenWidth-20, self.pieHight);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
#pragma mark - Lazy loading
- (UICollectionView *)collectionview{
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;//横向间距
        layout.minimumInteritemSpacing = 0;//纵向间距
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopBarHeight) collectionViewLayout:layout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.backgroundColor = kCorlorFromHexcode(0xfafafa);
        [_collectionview registerNib:[UINib nibWithNibName:NSStringFromClass([RingMainCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kRingMainCollectionViewCell];
    }
    return _collectionview;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
    }
    return _dataArray;
}


@end
