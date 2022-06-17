//
//  InfoPageViewController.m
//  Flixter
//
//  Created by Myles Block on 6/17/22.
//

#import "InfoPageViewController.h"
#import "UIImageview+AFNetworking.h"

@interface InfoPageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *MovieImage;
@property (weak, nonatomic) IBOutlet UILabel *MovieTitle;
@property (weak, nonatomic) IBOutlet UILabel *MovieDescription;

@end

@implementation InfoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.MovieTitle.text = self.detailDict[@"title"];
    self.MovieDescription.text = self.detailDict[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.detailDict[@"poster_path"];
    NSString *completePosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:completePosterURLString];
    [self.MovieImage setImageWithURL:posterURL];
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
