Love Live! School Idol Fest - Best Perfect Locker Team Organizer
================================================================

## Introduction

This project is a helper application to the mobile game __Love Live SIF__. Perfect locker cards, in the game, will cast effect that turns 'Good' and 'Great' beats into 'Perfect' for a certain length of time (typically 2-4 sec). The effect will be called repeatedly by a fixed interval or by some numbers of beats (notes), and for some likelyhood the effect will be cast successfully for each call. This project is aimed to build an web app that allows uses to select their perfect locker cards they have, and returns the best team avaliable.

## Features

Currently the web app is still building. The `table.html` conteins the perfect locker data currently avaliable, and the `gibbs_sampler_method_demo.R` script describes the method of generating the list.

Designed functionalities of the app:

* Users select their card from a given list, and can fix the values in the list manually (because the cards may have appeals levels greater than 1)
* Users can also add card information that are not contained in the data (because I do not have the hole data set and/or can not update the data on time)
* Users can select random seed, so that they can repeat the run for exact the same result. Or they can manually repeat the sampler for their preferred seed to check the consistancy of the result
* Users can get a code contains information of his/her query, and using this code they can repeat the result without setting the parameters and card list again

__If anyone can share with me a better database, please me please :)__

## Models

Gibbs sampler method is used to generate the team, via iteratively discard and insert card randomly, based on a probability list related to the conttributions of the cards to the team. The measure of effect is set to be the distribution of the possibility of effect on sate over the time course of the song.
$$Effect  =  \sum_T{(1 \ - \prod_i{(1 \ - \ Pr_{(Successfully\ Cast,\  Member\ i,\ T)})})}$$
First a random 9 member team is selected, the effect of that team is calculated.

For each Gibbs sampler turn, the _loss of effect_ value of each member in the current team is calculated. The _loss of effect_ for member _i_ is defined as the difference of effect between a team include and exclude that member _i_:
$$Loss\_of\_effect_i = Effect_{(member\ 1:9)} - Effect_{(members\ !i)}$$
And the propability of discard the _i^th^_ member is proportional to 
$$\frac{Loss\_of\_effect_i}{\{Loss\_of\_effect\}_max} - 1$$

After one member is discarded from the current team, the _gain of effect_ value of all absent members are calculated, including the member that just has left from the team. The value is similarly defined as the _loss of effect_ value, and also the probability of joining member _i_ into the team is proportional to a function of that value.

The Gibbs iteration stops when the maximal effect has occurs for a threshold time (in the demo script thresh = 50), or reaches the maximal iteration loop limit.

## Reference

- [Love Live!] Official Site
- The current card list is grabed from [Love Live! Chinese Wiki]