//
//  AddSubTripLocationViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/19.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AddSubTripLocationViewController.h"
#import "AddSubTripViewController.h"
#import "AddSubTripLocationMapTableViewCell.h"
#import "LocationAnnotation.h"
#import "CocoaSecurity.h"
#import "WTLocationManager.h"
#import "AFNetworking.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

static NSString * const BASE_DOMAIN = @"http://api.cc2me.com/";

#define BASE_URL BASE_DOMAIN

@interface AddSubTripLocationViewController ()<UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *coreLocationManager;
@property (nonatomic, strong) WTLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) UIButton *userLocationButton;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) NSString *nameLocation;
@property (nonatomic, strong) NSString *addressLocation;
@property (nonatomic, strong) NSString *latLocation;
@property (nonatomic, strong) NSString *lngLocation;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, retain) NSArray *tableArray;
@end

@implementation AddSubTripLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(navSaveBTN)];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"not work");
    }
    
    
    [self setupCoreLocationManager];
    
    [self setMapWithLocation];
    
    //iOS8定位机制改变
    if ([_coreLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_coreLocationManager performSelector:@selector(requestWhenInUseAuthorization)];
        [_coreLocationManager requestWhenInUseAuthorization];
    }else {
        // < iOS8
        [_coreLocationManager startUpdatingHeading];
    }
    
    
    
    
    [self setSearchBtn];
    
    [self setTableView];
    
    [self setupUserLocationBtn];
    
    [self setupViewForActivityIndicator];
}

#pragma  mark 按钮 - 定位用户当前位置
- (void) setupUserLocationBtn {
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.myTableView.hidden = YES;
    
    self.userLocationButton = [UIButton newAutoLayoutView];
    [self.view addSubview:self.userLocationButton];
    
    [_userLocationButton autoSetDimensionsToSize:CGSizeMake(44.0, 44.0)];
    [_userLocationButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10.0f];
    [_userLocationButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-40.0f];
    [_userLocationButton addTarget:self action:@selector(setUserCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    
    _userLocationButton.backgroundColor = [UIColor clearColor];
    [_userLocationButton setImage:[UIImage imageNamed:@"GetUserLocationCenter"] forState:UIControlStateNormal];
}

- (void) setTableView
{
    self.myTableView = [UITableView newAutoLayoutView];
    [self.view addSubview:self.myTableView];
    [_myTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.searchField withOffset:35.0];
    [_myTableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:20.0];
    [_myTableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-50.0];
    [_myTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-20.0];
    
    self.myTableView.hidden = YES;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerClass:[AddSubTripLocationMapTableViewCell class] forCellReuseIdentifier:@"addLocationCell"];
}

- (void) setupCoreLocationManager {
    self.coreLocationManager = [[CLLocationManager alloc] init];
    _coreLocationManager.delegate = self;
    //    _coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _coreLocationManager.distanceFilter = kCLHeadingFilterNone;
    [_coreLocationManager startUpdatingLocation];
}

# pragma mark 显示地图并地位当前位置
- (void) setMapWithLocation {
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _mapView.mapType = MKMapTypeStandard;
    
    _mapView.showsUserLocation = YES;
    
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 定位到用户当前地理位置
- (void) setUserCurrentLocation {
    
    self.myTableView.hidden = YES;
    
    self.locationManager = [WTLocationManager new];
    [_locationManager getCurrentLocationSuccess:^(CLLocationCoordinate2D location) {
        self.currentLocation = location;
    } failure:^(NSError *error) {
        NSLog(@"can not get current location");
    }];
    
    //    [self setMapAnnotationByGEO:_currentLocation.latitude longitude:_currentLocation.longitude title:NSLocalizedString(@"TEXT_LOCATION_CURRENT_TITLE", Nil)];
    [self setMapAnnotationByGEO:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude title:NSLocalizedString(@"TEXT_LOCATION_CURRENT_TITLE", Nil)];
    
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"system set userlocation");
}

- (void) setMapAnnotationByGEO:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude title:(NSString *)title{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    LocationAnnotation *annotation = [LocationAnnotation new];
    
    annotation.coordinate = (CLLocationCoordinate2D){latitude, longitude};
    
    annotation.title = title;
    
    [_mapView addAnnotation:annotation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(annotation.coordinate, span);
    
    [self.mapView setRegion:region animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [_searchField resignFirstResponder];
    return YES;
}

- (void) selectCellLocation:(NSIndexPath *) indexPath {
    _myTableView.hidden = YES;
    _searchField.text = [[_tableArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
}

- (void) setSearchBtn {
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, 70, self.view.frame.size.width - 50, 30)];
    _searchField.delegate = self;
    _searchField.borderStyle = UITextAutocapitalizationTypeWords;
    _searchField.backgroundColor = [UIColor whiteColor];
    _searchField.placeholder = NSLocalizedString(@"INPUT_SEARCH_LOCATION", Nil);
    _searchField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_searchField];
    
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 70, 50, 30)];
    _searchBtn.backgroundColor = [UIColor blackColor];
    [_searchBtn setTitle:NSLocalizedString(@"BTN_SEARCH", Nil) forState:UIControlStateNormal];
    
    [_searchBtn addTarget:self action:@selector(searchLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchBtn];
    
}

- (void) searchLocation
{
    [self.searchField resignFirstResponder];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"3ffd59f6-d5c6-12b2-d930-683c5ecd8f8e" forKey:@"ssid"];
    [parameters setObject:_searchField.text forKey:@"hotel_name"];
    [parameters setObject:@"34.417740,108.738571" forKey:@"location"];
    [parameters setObject:@"true" forKey:@"other_type"];
    
    
    NSString *cerString = [self encrytionKeyWithParameters:parameters specialString:@"ooxx"];
    
    NSLog(@"cer string is %@", cerString);
    
    NSMutableDictionary *paramWithCer = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [paramWithCer setObject:cerString forKey:@"cer"];
    
    
    [self showActivityIndicatorView:YES];
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    [manager GET:@"Hotel/searchAd" parameters:paramWithCer success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON is %@ ", responseObject);
        
        //        NSDictionary *tmpDic = [[NSDictionary alloc] initWithDictionary:[responseObject objectForKey:@"hotels"]];
        self.tableArray = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"hotels"]];
        [self.myTableView reloadData];
        self.myTableView.hidden = NO;
        [self showActivityIndicatorView:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error is %@ ", error);
        [self showActivityIndicatorView:NO];
    }];
}

//生成加密key
- (NSString *)encrytionKeyWithParameters:(NSDictionary *)parameters
                           specialString:(NSString *)specialStr {
    
    NSArray *allKeys = [parameters allKeys];
    NSArray *sortedAllKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSString *key in sortedAllKeys) {
        id value = parameters[key];
        if ([value isKindOfClass:[NSNumber class]]) {
            NSString *numberString = [NSString stringWithFormat:@"%@", [value stringValue]];
            [values addObject:numberString];
        }else if ([value isKindOfClass:[NSString class]]) {
            [values addObject:value];
        } else {
            NSLog(@"加密key异常！！");
        }
    }
    
    NSMutableString *keyString = [NSMutableString string];
    
    //连接value，以specialStr隔开
    for (NSString *value in values) {
        [keyString appendString:value];
        [keyString appendString:specialStr];
    }
    
    NSInteger sortedAllKeysCount = [sortedAllKeys count];
    
    //连接key值，以specialStr隔开
    for (NSInteger i = 0; i < sortedAllKeysCount; i++) {
        [keyString appendString:sortedAllKeys[i]];
        if (i != sortedAllKeysCount - 1) {
            [keyString appendString:specialStr];
        }
    }
    
    NSLog(@"拼接结果:%@", keyString);
    
    return [[CocoaSecurity sha1:keyString] hexLower];
}

#pragma mark 导航保存按钮
- (void) navSaveBTN
{
    
    [self.AddSubLocationDelegate setupSubLocationText:_addressLocation Lat:_latLocation Lng:_lngLocation];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

# pragma mark - tableview

- (NSInteger ) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.tableArray count]) {
        return [self.tableArray count];
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddSubTripLocationMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addLocationCell" forIndexPath:indexPath];
    
    cell.nameLB.text = [[_tableArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.addressLB.text = [[_tableArray objectAtIndex:indexPath.row] objectForKey:@"address"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectCellLocation:indexPath];
    
    self.nameLocation = [[_tableArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    self.addressLocation = [[_tableArray objectAtIndex:indexPath.row] objectForKey:@"address"];
    self.latLocation = [[_tableArray objectAtIndex:indexPath.row] objectForKey:@"latitude"];
    self.lngLocation = [[_tableArray objectAtIndex:indexPath.row] objectForKey:@"longitude"];
    
    double latitude = [self.latLocation floatValue];
    double longitude = [self.lngLocation floatValue];
    NSString *title = self.nameLocation;
    [self setMapAnnotationByGEO:latitude longitude:longitude title:title];
}

#pragma mark 设置小菊花
-(void)setupViewForActivityIndicator
{
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //创建一个UIActivityIndicatorView对象：_activityIndicatorView，并初始化风格。
    
    //        _activityIndicatorView.frame = CGRectMake(160, 230, 0, 0);
    _activityIndicatorView.frame = CGRectMake(self.view.frame.size.width-60, 85, 0, 0);
    //设置对象的位置，大小是固定不变的。WhiteLarge为37 * 37，White为20 * 20
    
    _activityIndicatorView.color = [UIColor blackColor];
    
    //设置活动指示器的颜色
    //    [self.searchField addSubview:_activityIndicatorView];
    [self.view addSubview:_activityIndicatorView];
}

#pragma mark - activityIndicator open/close
-(void)showActivityIndicatorView:(BOOL)isOpen
{
    isOpen? [_activityIndicatorView startAnimating]: [_activityIndicatorView stopAnimating];
    
    //开始动画
}

@end
