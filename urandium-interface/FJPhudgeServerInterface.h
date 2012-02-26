//
//  FJPhudgeServerInterface.h
//  urandium-interface
//
//  Created by Engin Kurutepe on 2/26/12.
//  Copyright (c) 2012 Fifteen Jugglers Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^FJSimpleAction)();
typedef void (^FJImageAction)(UIImage* image);
typedef void (^FJArrayAction)(NSArray* array);

#define SERVER_URL @"http://furious-fog-6463.herokuapp.com"
#define FJPhudgerServerImageTypeRaw @"raw"
#define FJPhudgerServerImageTypeFinal @"final"

@interface FJPhudgeServerInterface : NSObject

+ (FJPhudgeServerInterface*) sharedInterface;
+ (NSString*)base64forData:(NSData*)theData;


- (void) getImageWithBlock:(FJImageAction)finished;
- (void) getStreamWithBlock:(FJArrayAction)finished;
- (void) uploadImage:(UIImage*)image withType:(NSString*)type andLocation:(CLLocation*)location;

@end
