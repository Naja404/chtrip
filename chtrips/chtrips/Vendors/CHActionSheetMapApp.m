//
//  CHActionSheetMapApp.m
//  chtrips
//
//  Created by Hisoka on 15/11/27.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "CHActionSheetMapApp.h"

@interface CHActionSheetMapApp()<UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *mapSchemeUrlArr;
@property (nonatomic, strong) NSMutableArray *mapAppInstalledArr;
@property (nonatomic, strong) NSURL *appUrl;

@end

@implementation CHActionSheetMapApp

#pragma mark - 检测已安装的地图app
- (void) checkMapApp {
    
    self.mapSchemeUrlArr = @[@"iosamap", @"baidumap", @"comgooglemaps"];
    self.mapAppInstalledArr = [NSMutableArray arrayWithCapacity:1];
    self.mapAS = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"TEXT_MAP_SELECT", nil)
                                             delegate:self
                                    cancelButtonTitle:NSLocalizedString(@"BTN_CANCEL", nil)
                               destructiveButtonTitle:nil
                                    otherButtonTitles:nil];
    
    [_mapAS addButtonWithTitle:NSLocalizedString(@"applemap", nil)];
    
    [_mapSchemeUrlArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *tmpUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", obj]];
        if ([[UIApplication sharedApplication] canOpenURL:tmpUrl]) {
            [_mapAS addButtonWithTitle:NSLocalizedString(obj, nil)];
        }
    }];
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) return;
    
    NSString *selectTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([selectTitle isEqualToString:NSLocalizedString(@"iosamap", nil)]) {
        self.appUrl = [NSURL URLWithString:@"iosamap://"];
    }else if ([selectTitle isEqualToString:NSLocalizedString(@"baidumap", nil)]) {
        self.appUrl = [NSURL URLWithString:@"baidumap://"];
    }else if ([selectTitle isEqualToString:NSLocalizedString(@"comgooglemaps", nil)]){
        self.appUrl = [NSURL URLWithString:@"comgooglemaps://"];
    }else {
        NSString *tmpUrl = [[NSString stringWithFormat:@"http://maps.apple.com/?q=%@", self.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.appUrl = [NSURL URLWithString:tmpUrl];
    }
    
    [[UIApplication sharedApplication] openURL:_appUrl];
}

- (instancetype) initWithMap:(id<CHActionSheetMapAppDelegate>)delegate {
    
    self = [super init];
    
    if (self) {
        [self checkMapApp];
    }
    
    return self;
}

- (void) dismiss {
    
}

@end
