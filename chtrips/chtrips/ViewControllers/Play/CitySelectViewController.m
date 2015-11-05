//
//  CitySelectViewController.m
//  chtrips
//
//  Created by Hisoka on 15/9/27.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "CitySelectViewController.h"
#import "CitySelectCollectionViewCell.h"
#import "UIViewController+BackItem.h"

static NSString * const CITY_CELL = @"cityCell";

@interface CitySelectViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *cityCV;

@end

@implementation CitySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupStyle];
    [self customizeBackItemWithDismiss];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void) setupStyle {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.cityCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
    
    self.cityCV.delegate = self;
    self.cityCV.dataSource = self;
    self.cityCV.backgroundColor = [UIColor whiteColor];
    
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
    
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.cityData objectAtIndex:indexPath.row]];
    
    cell.cityLB.text = [cellData objectForKey:@"name"];
    
    NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"pic_url"]];
    [cell.cityImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicSmall"]];
    
    UITapGestureRecognizer *onceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCityBTN:)];
    cell.cityBTN.userInteractionEnabled = YES;
    [cell.cityBTN addGestureRecognizer:onceTap];
    
    cell.cityIndexPath = indexPath;
    cell.cityNameStr = [cellData objectForKey:@"name"];
    
    return cell;
}

- (void) clickCityBTN: (UITapGestureRecognizer *)gr {

    CitySelectCollectionViewCell *cell = (CitySelectCollectionViewCell *) [[gr view] superview];
    
    [self.delegate didSelectCity:cell.cityNameStr];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 定义每个collectionview 大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth - 60) / 2 , (ScreenWidth - 60) / 2 / 2.7);
}

// 定义每个 collectionview 间距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 20, 10, 20);
}

//定义每个 collectionview 纵向间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

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
