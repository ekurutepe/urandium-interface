//
//  FJViewController.m
//  urandium-interface
//
//  Created by Engin Kurutepe on 2/26/12.
//  Copyright (c) 2012 Fifteen Jugglers Software. All rights reserved.
//

#import "FJViewController.h"
#import "FJPhudgeServerInterface.h"

@interface FJViewController ()

@end

@implementation FJViewController

@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction) uploadTapped:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:picker animated:YES];
}

- (IBAction) getImageTapped:(id)sender
{
    [[FJPhudgeServerInterface sharedInterface] getImageWithBlock:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [[FJPhudgeServerInterface sharedInterface] uploadImage:image
                                                  withType:FJPhudgerServerImageTypeRaw
                                               andLocation:nil];
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
