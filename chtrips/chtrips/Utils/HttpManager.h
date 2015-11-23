//
//  HttpManager.h
//  chtrips
//
//  Created by Hisoka on 15/5/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

static NSString * const BASE_DOMAIN = @"http://api.nijigo.com";
static NSString * const KEY_SSID = @"ssid";
static NSString * const ERROR_DOMAIN_API = @"ServiceError";


#define BASE_URL BASE_DOMAIN

typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface HttpManager : NSObject

@property (nonatomic, strong) NSOperationQueue * operationQueue;
@property (nonatomic) BOOL hasRequestOperation;

+ (instancetype) instance;

// 取消所有请求
- (void) cancelAllOperations;

- (HttpManager *)requestWithMethod:(NSString *)method
                          parameters:(NSDictionary *)parameters
                             success:(void (^)(NSDictionary *result))success
                             failure:(FailureBlock)failure;

- (HttpManager *)requestWithMethod:(NSString *)method
                          parameters:(NSDictionary *)parameters
                          httpMethod:(NSString *)getOrPost
                             success:(void (^)(NSDictionary *result))success
                             failure:(FailureBlock)failure;

- (HttpManager *) uploadFile:(NSString *)url
                   imageData:(UIImage *)imageData
                  parameters:(NSDictionary *) parameters
                     success:(void (^)(NSDictionary *result))success
                     failure:(FailureBlock)failure;
@end
