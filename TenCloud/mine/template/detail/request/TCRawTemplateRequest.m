//
//  TCRawTemplateRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCRawTemplateRequest.h"
//#import "TCCorp+CoreDataClass.h"
#import "TCTemplateSegment+CoreDataClass.h"

@interface TCRawTemplateRequest()
@property (nonatomic, assign)   NSInteger     corpID;
@end

@implementation TCRawTemplateRequest

- (instancetype) initWithCorpID:(NSInteger)cid
{
    self = [super init];
    if (self)
    {
        _corpID = cid;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSArray<TCTemplateSegment *> *segArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *dataArray = [request.responseJSONObject objectForKey:@"data"];
        if (dataArray)
        {
            NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
            NSArray *segmentArray = [TCTemplateSegment mj_objectArrayWithKeyValuesArray:dataArray context:context];
            success ? success (segmentArray) : nil;
        }
        /*
        if (corpDictArray && corpDictArray.count >= 1)
        {
            NSDictionary *corpDict = corpDictArray.firstObject;
            NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
            TCCorp *corp = [TCCorp mj_objectWithKeyValues:corpDict context:context];
            success ? success(corp) : nil;
        }
         */
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/permission/resource/%ld",_corpID];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

/*
- (id)requestArgument
{
    return nil;
}
 */

@end
