//
//  TCTagListRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCTagListRequest.h"
#import "TCEditTag.h"

@interface TCTagListRequest()
@end

@implementation TCTagListRequest

- (void) startWithSuccess:(void(^)(NSArray<TCEditTag*> *tagArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *resArray = [self resultTagArray];
        success ? success(resArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSArray<TCEditTag*> *)resultTagArray
{
    NSDictionary *arrayDict = [self.responseJSONObject objectForKey:@"data"];
    //NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    //NSArray *resArray = [TCEditTag mj_objectArrayWithKeyValuesArray:arrayDict context:context];
    NSArray *resArray = [TCEditTag mj_objectArrayWithKeyValuesArray:arrayDict];
    return resArray;
}

- (NSString *)requestUrl {
    return @"/api/label/list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return @{@"type":@(1)};
}

@end
