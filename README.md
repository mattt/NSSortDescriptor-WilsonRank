# NSSortDescriptor+WilsonRank

**The Correct Way To Rank Up/Down Voted Items**

Let's say you have a collection of items, each of which have been rated thumbs positively or negatively a certain number of times. Maybe it's products on an e-commerce store, or links submitted to a popular hacker community.

_How do we rank them?_

Sorting by positive vs. negative % alone gives undue advantage to items with fewer ratings, whereas sorting by total number of positive ratings makes it difficult for new items to break into the top.

Fortunately, there _is_ a correct solution: **use the lower bound of Wilson score confidence interval for a Bernoulli parameter**.

As eloquently described by [Evan Miller](http://www.evanmiller.org/how-not-to-sort-by-average-rating.html#changes):

> We need to balance the proportion of positive ratings with the uncertainty of a small number of observations. Fortunately, the math for this was worked out in 1927 by Edwin B. Wilson. What we want to ask is: _Given the ratings I have, there is a 95% chance that the "real" fraction of positive ratings is at least what?_ Wilson gives the answer. Considering only positive and negative ratings (i.e. not a 5-star scale), the lower bound on the proportion of positive ratings is given by:

<figure style="text-align:center">
    <img title="$$\left ( \hat{p} + \frac{z^{2}_{\alpha/2}}{2n} \pm z_{\alpha/2} \sqrt{[\hat{p}(1 - \hat{p}) + z^{2}_{\alpha / 2} / 4n] / n} \right ) / (1 + z^{2}_{\alpha / 2} / n).$$" src="http://latex.codecogs.com/svg.latex?\inline&space;\large&space;\left&space;(&space;\hat{p}&space;+&space;\frac{z^{2}_{\alpha/2}}{2n}&space;\pm&space;z_{\alpha/2}&space;\sqrt{[\hat{p}(1&space;-&space;\hat{p})&space;+&space;z^{2}_{\alpha&space;/&space;2}&space;/&space;4n]&space;/&space;n}&space;\right&space;)&space;/&space;(1&space;+&space;z^{2}_{\alpha&space;/&space;2}&space;/&space;n)."/>
</figure>

> Here p̂ is the observed fraction of positive ratings, zα/2 is the (1-α/2) quantile of the standard normal distribution, and n is the total number of ratings.

## Usage

```objective-c
NSArray *fruits = @[@{@"name": @"apple", @"up": @(77), @"down": @(14)},
                    @{@"name": @"banana", @"up": @(90), @"down": @(78)},
                    @{@"name": @"cherry", @"up": @(28), @"down": @(6)},
                    @{@"name": @"durian", @"up": @(2), @"down": @(43)},
                    @{@"name": @"elderberry", @"up": @(81), @"down": @(42)},
                    @{@"name": @"fig", @"up": @(70), @"down": @(93)},
                    @{@"name": @"grape", @"up": @(48), @"down": @(89)},
                    @{@"name": @"honeydew", @"up": @(65), @"down": @(26)},
                    ];

NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor wilsonRankSortDescriptorWithPositiveKey:@"up"
                                                  negativeKey:@"down"
                                                    ascending:NO];

for (id fruit in [fruits sortedArrayUsingDescriptors:@[sortDescriptor]]) {
    NSLog(@"%@ (%@↑ / %@↓)", fruit[@"name"], fruit[@"up"], fruit[@"down"]);
}
```

### Results

* apple (77↑ / 14↓)
* cherry (28↑ / 6↓)
* honeydew (65↑ / 26↓)
* elderberry (81↑ / 42↓)
* banana (90↑ / 78↓)
* fig (70↑ / 93↓)
* grape (48↑ / 89↓)
* durian (2↑ / 43↓)

### Contact

[Mattt](https://twitter.com/mattt)

## License

NSSortDescriptor+WilsonRank is available under the MIT license. See the LICENSE file for more info.
