//
//  PCChallengeAPIManager.m
//  PCChallenege
//
//  Created by Kaushik on 1/6/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import "PCChallengeAPIManager.h"
#import "PCCXMLParser.h"
#import "PCCItem.h"

@implementation PCChallengeAPIManager

+ (id)sharedManager {
    static PCChallengeAPIManager *_apiManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _apiManager = [[self alloc] init];
    });
    
    return _apiManager;
}


- (void)loadRequestWithPath:(NSString *)path completion:(void (^)(id data, NSError *error))completion
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        if (data) {
            if (completion) {
                completion(data, error);
            }
        }
    }];
    
    [dataTask resume];

}
@end
