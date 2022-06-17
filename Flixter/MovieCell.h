//
//  MovieCell.h
//  Flixter
//
//  Created by Myles Block on 6/17/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *MovieImage;
@property (weak, nonatomic) IBOutlet UILabel *MovieTitle;
@property (weak, nonatomic) IBOutlet UILabel *MovieDescription;

@end

NS_ASSUME_NONNULL_END
