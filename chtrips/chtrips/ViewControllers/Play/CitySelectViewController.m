//
//  CitySelectViewController.m
//  chtrips
//
//  Created by Hisoka on 15/9/27.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "CitySelectViewController.h"
#import "CitySelectCollectionViewCell.h"

static NSString * const CITY_CELL = @"cityCell";

@interface CitySelectViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *cityCV;

@end

@implementation CitySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupStyle];
}

- (void) setupStyle {
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBuyContent)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectedCityAction)];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.cityCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
    
    self.cityCV.delegate = self;
    self.cityCV.dataSource = self;
    
    [self.view addSubview:_cityCV];
    
    [self.cityCV registerClass:[CitySelectCollectionViewCell class] forCellWithReuseIdentifier:CITY_CELL];
    
}

- (void) selectedCityAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.cityData count] <= 0) {
        return 0;
    }else{
        return [self.cityData count];
    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CitySelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CITY_CELL forIndexPath:indexPath];
    
//    cell.cityLB.text = [self.cityData objectAtIndex:indexPath.row];
    
    [cell.cityBTN setTitle:[self.cityData objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *onceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCityBTN:)];
    cell.cityBTN.userInteractionEnabled = YES;
    [cell.cityBTN addGestureRecognizer:onceTap];
    
    cell.cityIndexPath = indexPath;
    
    return cell;
}

- (void) clickCityBTN: (UITapGestureRecognizer *)gr {

    CitySelectCollectionViewCell *cell = (CitySelectCollectionViewCell *) [[[gr view] superview] superview];
    
    self.selectedCity = [self.cityData objectAtIndex:cell.cityIndexPath.row];
    
    
    
}

// 定义每个collectionview 大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 30);
}

// 定义每个 collectionview 间距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 5, 5);
}

//定义每个 collectionview 纵向间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select %@", indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
