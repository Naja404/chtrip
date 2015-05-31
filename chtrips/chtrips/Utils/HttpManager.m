//
//  HttpManager.m
//  chtrips
//
//  Created by Hisoka on 15/5/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "HttpManager.h"

static NSString * const RESPONSE_STATUS = @"status";
static NSString * const RESPONSE_ERROR = @"error";

typedef void (^SuccessBlock) (NSDictionary *result);

@interface HttpManager()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) SuccessBlock successBlock;
@property (nonatomic, strong) FailureBlock failureBlock;
@property (nonatomic, strong) NSCache *versionCache;
@property (nonatomic, strong) NSString *currentVersion;

@end

@implementation HttpManager

+ (instancetype)instance {
    return [[HttpManager alloc] init];
}

- (void) cancelAllOperations {
    [self.manager.operationQueue cancelAllOperations];
}

- (NSOperationQueue *) operationQueue {
    return self.manager.operationQueue;
}

- (BOOL) hasRequestOperation {
    return self.manager.operationQueue.operations.count > 0;
}

- (NSCache *) versionCache {
    if (!_versionCache) {
        _versionCache = [NSCache new];
    }
    
    return _versionCache;
}

- (NSString *) currentVersion {
    NSString *version = [self.versionCache objectForKey:@"version_cache"];
    if (!version) {
        version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    
    [self.versionCache setObject:version forKey:@"version_cache"];
    
    return version;
}

- (HttpManager *)requestWithMethod:(NSString *)method
                          parameters:(NSDictionary *)parameters
                             success:(void (^)(NSDictionary *result))success
                             failure:(FailureBlock)failure
{
    return [self requestWithMethod:method parameters:parameters httpMethod:@"GET" success:success failure:failure];
}

- (HttpManager *) requestWithMethod:(NSString *)method
                         parameters:(NSDictionary *) parameters
                         httpMethod:(NSString *) getOrPost
                            success:(void (^)(NSDictionary *result))success
                            failure:(FailureBlock)failure {
    _successBlock = success;
    _failureBlock = failure;
    
    self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    [_manager.requestSerializer setValue:self.currentVersion forHTTPHeaderField:@"app_version"];
    
    if ([getOrPost isEqualToString:@"GET"]) {
        [_manager GET:method
           parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [self dealWithSuccessResponse:operation responseObject:responseObject];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self dealWithFailureResponse:operation error:error];
              }];
    }else if([getOrPost isEqualToString:@"POST"]) {
        [_manager POST:method
            parameters:parameters
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   [self dealWithSuccessResponse:operation responseObject:responseObject];
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   [self dealWithFailureResponse:operation error:error];
               }];
    }
    
    return self;
}

// 判断接口返回状态
- (void) dealWithSuccessResponse:(AFHTTPRequestOperation *) operation responseObject:(id)responseObject {
    BOOL isSuccess = NO;
    
    id status = responseObject[RESPONSE_STATUS];
    
    if ([status isKindOfClass:[NSNumber class]]) {
        isSuccess = [status isEqualToNumber:[NSNumber numberWithInteger:0]];
    }else if([status isKindOfClass:[NSString class]]) {
        isSuccess = [status isEqualToString:@"0"];
    }
    
    if (isSuccess) {
        _successBlock(responseObject);
    }else{
        NSError *error = nil;
        NSMutableDictionary *details = [NSMutableDictionary dictionary];
        
        NSString *errorString = responseObject[RESPONSE_ERROR];
        NSLog(@"error:%@", errorString);
        
        if (errorString) {
            [details setValue:errorString forKey:NSLocalizedDescriptionKey];
        }
        
        error = [NSError errorWithDomain:ERROR_DOMAIN_API code:100 userInfo:details];
        _failureBlock(operation, error);
    }
}

- (void)dealWithFailureResponse:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    _failureBlock(operation,error);
}




@end
