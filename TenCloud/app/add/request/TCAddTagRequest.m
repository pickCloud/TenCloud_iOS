//
//  TCAddTagRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAddTagRequest.h"

@interface TCAddTagRequest()
@end

@implementation TCAddTagRequest

- (void) startWithSuccess:(void(^)(NSInteger tagID))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        if (dataDict && [dataDict isKindOfClass:[NSDictionary class]])
        {
            NSNumber *tagIDNum = [dataDict objectForKey:@"id"];
            success ? success (tagIDNum.integerValue) : nil;
        }else
        {
            success ? success(0) : nil;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/label/new";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"name":_name,
             @"type":@(1)
             };
}

@end
