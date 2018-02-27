//
//  TCAddCorpRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAddCorpRequest.h"

@interface TCAddCorpRequest()
@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, strong)   NSString    *contact;
@property (nonatomic, strong)   NSString    *phone;
@end

@implementation TCAddCorpRequest

- (instancetype) initWithName:(NSString *)name contact:(NSString *)contact
                        phone:(NSString *)phone
{
    self = [super init];
    if (self)
    {
        _name = name;
        _contact = contact;
        _phone = phone;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSInteger corpID))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        if (dataDict)
        {
            NSNumber *cidNum = [dataDict objectForKey:@"cid"];
            success ? success (cidNum.integerValue) : nil;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/company/new";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"name":_name,
             @"contact":_contact,
             @"mobile":_phone,
             @"cid":@(0)
             };
}

@end
