//
//  PCChallengeAPIManager.h
//  PCChallenege
//
//  Created by Kaushik on 1/6/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCChallengeAPIManager : NSObject

+ (id)sharedManager;

- (void)loadRequestWithPath:(NSString *)path completion:(void (^)(id data, NSError *error))completion;

@end
