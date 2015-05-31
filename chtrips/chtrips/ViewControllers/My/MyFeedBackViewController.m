//
//  MyFeedBackViewController.m
//  chtrips
//
//  Created by Hisoka on 15/5/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyFeedBackViewController.h"
#import "AFNetworking.h"

@interface MyFeedBackViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation MyFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setupStyle {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textView = [[UITextView alloc] initForAutoLayout];
    [self.view addSubview:self.textView];
    
    [self.textView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [self.textView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.textView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.textView autoSetDimension:ALDimensionHeight toSize:200.0];
    
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    
    self.textView.textColor = COLOR_TEXT;
    self.textView.font = FONT_TEXT;
    self.textView.text =  NSLocalizedString(@"TEXT_FEEDBACK_DEFAULT", Nil);
    self.textView.textColor = [UIColor lightGrayColor];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_SUBMIT", Nil)
                                                                style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    rightBtn.enabled = NO;
    
}

- (void)submit {
    NSString *text = self.textView.text;
    NSString *trimedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (trimedText.length == 0) {
        return;
    }

    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:trimedText forKey:@"content"];
    [parameters setObject:[CHSSID SSID] forKey:@"token"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.atniwo.com/"]];
    [manager GET:@"Util/feedback" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON is %@ ", responseObject);
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_FEEDBACK_SEND_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error is %@ ", error);
    }];
    
//    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_FEEDBACK_SEND_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark - TextView Delegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = @"";
    _textView.textColor = COLOR_TEXT;
    
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView {
    if ([textView.text length] > 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }else{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

@end
