//
//  TCCorpListRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCorpListRequest.h"
#import "TCListCorp+CoreDataClass.h"

@interface TCCorpListRequest()
@property (nonatomic, assign)       NSInteger       status;
@end

@implementation TCCorpListRequest


- (instancetype) initWithStatus:(NSInteger)status
{
    self = [super init];
    if (self)
    {
        _status = status;
        //self.ignoreCache = YES;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSArray<TCListCorp*> *corpArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *resArray = [self resultCorpArray];
        success ? success(resArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSArray<TCListCorp*> *)resultCorpArray
{
    NSDictionary *arrayDict = [self.responseJSONObject objectForKey:@"data"];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *resArray = [TCListCorp mj_objectArrayWithKeyValuesArray:arrayDict context:context];
    return resArray;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/companies/list/%ld",_status];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

//- (NSInteger)cacheTimeInSeconds
//{
//    return  NSIntegerMax;
//}

@end
