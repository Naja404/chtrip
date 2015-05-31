//
//  BuyListViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "BuyListViewController.h"
#import "AddBuyViewController.h"
#import "BuyListTableViewCell.h"

#import "BuyList.h"
#import "ChtripCDManager.h"

static NSString * const BUY_LIST_CELL = @"BuyListCell";

@interface BuyListViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *buyListTV;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation BuyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupStyle];
    [self setupBuyListTV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 设置样式
- (void) setupStyle
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"TEXT_BUYLIST_TITLE", Nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBuyContent)];
}

#pragma mark fetch 数据
- (NSFetchedResultsController *) fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *tripEntiry = [NSEntityDescription entityForName:@"BuyList" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    
    [fetchRequest setEntity:tripEntiry];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"keyID = %@", self.keyID];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:[CoreDataManager sharedManager].managedObjectContext
                                                                      sectionNameKeyPath:Nil
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error = NULL;
    
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark 更新fetch数据
- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.buyListTV;
    
    if (type == NSFetchedResultsChangeInsert) {
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.buyListTV reloadData];
    [self.buyListTV endUpdates];
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.buyListTV beginUpdates];
}

#pragma mark 设置tableview
- (void) setupBuyListTV
{
    self.buyListTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_buyListTV];
    
    [_buyListTV autoPinToTopLayoutGuideOfViewController:self withInset:-65.0];
    [_buyListTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_buyListTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_buyListTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _buyListTV.dataSource = self;
    _buyListTV.delegate = self;
    _buyListTV.separatorStyle = UITableViewCellAccessoryNone;
    
    [self.buyListTV registerClass:[BuyListTableViewCell class] forCellReuseIdentifier:BUY_LIST_CELL];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BUY_LIST_CELL forIndexPath:indexPath];
    
    BuyList *buy = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.contentLB.text = buy.content;
    
    if ([buy.checkStatus isEqualToString:@"1"]) {
        cell.checkBoxImg.image = [UIImage imageNamed:@"checkboxChecked"];
        cell.contentLB.textColor = [UIColor grayColor];
    }else{
        cell.checkBoxImg.image = [UIImage imageNamed:@"checkboxUncheck"];
        cell.contentLB.textColor = [UIColor blackColor];
    }
    
    cell.buyID = buy.buyID;
    cell.checkStatus = buy.checkStatus;
    
    UITapGestureRecognizer *onceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickCheckBox:)];
    cell.checkBoxImg.userInteractionEnabled = YES;
    [cell.checkBoxImg addGestureRecognizer:onceTap];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark 添加欲购内容
- (void) addBuyContent
{
    
    AddBuyViewController *addBuyVC = [[AddBuyViewController alloc] init];

    addBuyVC.keyID = self.keyID;
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addBuyVC];
//    addBuyVC.navigationItem.title = NSLocalizedString(@"TEXT_ADD_SUBTRIP", Nil);
    
    [self.navigationController presentViewController:navVC animated:YES completion:nil];

}

#pragma mark 点击复选按钮
- (void) onClickCheckBox:(UITapGestureRecognizer *) gr
{
    BuyListTableViewCell *cell = (BuyListTableViewCell *) [[[gr view] superview] superview];
    
    ChtripCDManager *tripCD = [[ChtripCDManager alloc] init];
    
    NSString *checkStatus = @"1";
    
    if ([cell.checkStatus isEqualToString:@"1"]) {
        checkStatus = @"0";
    }
    
    NSDictionary *buyData = [[NSDictionary alloc] initWithObjectsAndKeys:cell.buyID, @"buyID",
                                                                        checkStatus, @"checkStatus",
                                                                        nil];
    if ([tripCD updateBuy:buyData]) {
        if ([checkStatus isEqualToString:@"1"]) {
            cell.checkBoxImg.image = [UIImage imageNamed:@"checkboxChecked"];
            cell.contentLB.textColor = [UIColor grayColor];
        }else{
            cell.checkBoxImg.image = [UIImage imageNamed:@"checkboxUncheck"];
            cell.contentLB.textColor = [UIColor blackColor];
        }
    }
    
}

@end
