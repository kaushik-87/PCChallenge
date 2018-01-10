//
//  PCCXMLParser.h
//  PCChallenege
//
//  Created by Kaushik on 1/6/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^MyCompletionBlock)(NSArray *items, NSError *error);
@interface PCCXMLParser : NSObject<NSXMLParserDelegate>
@property (nonatomic) MyCompletionBlock completion;

- (void)parseData:(NSData *)data completionBlock:(MyCompletionBlock)completion;

@end
