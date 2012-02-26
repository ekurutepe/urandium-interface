//
//  FJViewController.h
//  urandium-interface
//
//  Created by Engin Kurutepe on 2/26/12.
//  Copyright (c) 2012 Fifteen Jugglers Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FJViewController : UIViewController <UIImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView * imageView;

- (IBAction) uploadTapped:(id)sender;
- (IBAction) getImageTapped:(id)sender;


@end
