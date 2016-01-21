//
//  MyWebViewController.h
//  chtrips
//
//  Created by Hisoka on 16/1/5.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebViewController : UIViewController

@property (nonatomic, strong) NSString *webUrl;
@property (nonatomic, strong) NSString *actionName;
@property (nonatomic, assign) BOOL isRoot;

@end
