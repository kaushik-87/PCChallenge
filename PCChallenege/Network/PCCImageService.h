//
//  PCCImageService.h
//  PCChallenege
//
//  Created by Kaushik on 1/8/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 Image caching class to cache the downloaded images. 
 */
@interface PCCImageService : NSObject{
}

+ (id)sharedService;

- (void)getItemImage: (NSString *) imagePath
           completion: (void (^)(UIImage * image)) handler;
@end
