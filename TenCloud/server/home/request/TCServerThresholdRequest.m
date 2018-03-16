//
//  TCServerThresholdRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerThresholdRequest.h"
#import "TCServerThreshold+CoreDataClass.h"


@interface TCServerThresholdRequest()

@end

@implementation TCServerThresholdRequest

- (void) startWithSuccess:(void(^)(TCServerThreshold *threshold))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        TCServerThreshold *threshold = [TCServerThreshold mj_objectWithKeyValues:dataDict context:context];
        success ? success(threshold) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/server/threshold";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return nil;
}

@end
