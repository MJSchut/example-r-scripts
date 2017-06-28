################################
# basic R script v1.01
################################
# this script includes some pseudocode to help you
# on your way to analyse stuff in R.
# when in doubt, google, someone will probably have 
# solved the problem you're facing.
################################
# By: Martijn Schut
# Date: 06/28/2017
# E: m.j.schut@uu.nl

################################
# 1. load data
# you can also use read.table if you have tabs or whatever as seperators
# this assumes commas as collumn seperators
# lastly, make sure you use '/' and not '\' when secifying file paths
df = read.csv("C:/Users/.../Output_complete.txt", header = TRUE)

################################
# 2a. data processing
# i.e. exclude what you want to exclude
# in this case we include a row if exclusion is equal to zero
df.exclusion = df[df$exclusion == 0,]

################################
# 2b. note on data format
# make sure your data is in long format
# e.g. 
# participant dependent trial condition1 condition 2
# 1           0.5       1     0          0
# 1           0.3       2     1          0
# 1           0.4       3     0          1
# 1           0.7       4     1          1
# 1           0.6       5     1          0
# 1           0.4       6     0          0
# 1           0.3       7     1          1
# 1           0.8       8     0          1
# 2           0.2       1     1          0
# etc.
# I recommend using the tidyr package (gather() and spread())
# install this using the install.packages("tidyr") command
# and load the library using library(tidyr) (pay attention to the "quotation" marks).
# If you can't manage doing this in R, do it in excel or whatever instead
# and then reload your dataset

################################
# 3. data analysis
# here we do a linear model, if you want to do anova's, etc.
# check if there's a package available, for example lme4 for
# linear mixed models. All you have to do then is replace
# 'lm' with 'lmer' for a linear mixed model (and specify 
# a random term (e.g. (1|pp) for random intercept per participant)).
################################
# lastly, check the syntax for including and excluding independent terms
# e.g. factor1 + factor2 is just main effects
# factor1 : factor2 is only interaction effect
# factor1 * factor 2 is main effects AND interaction effect
regression.1 = lm(dependent ~ factor1 * factor2,
                  data = df.exclusion)

################################
# 4. get results from regression
# This wil return the intercept and slope and test statistic (p value)
summary(regression.1)

################################
# 5. plot your regression
# this basically makes a new collumn with the predicted value
# based on your linear regression
# predict(model) is your friend
df.exclusion$predicted.dependent = predict(regression.1)
plot(df.exclusion$predicted.dependent)

################################
# 6. plot your regression like a pro
# use the ggplot package
# if you haven't installed it yet use install.packages("ggplot2")
# then run the following code
# load the library
require(ggplot2)

# main plotting argument, we are telling ggplot we want
# factor1 on the x axis, our predicted dependent on the y axis and
# two seperate lines for factor 2
# because we specify it under ggplot, we don't need to respecify when
# adding points and lines to our graph
plt = ggplot(aes(x = factor1, y = predicted.dependent, color = factor2), data = df.exclusion)
# lets add some points and lines to our graph
plt + geom_point()
plt + geom_line()
# lets change the labels
plt + xlab("Chance your name is Martijn")
plt + ylab("Superior R Skillz (degrees)")
# want to use a more minimalistic plotting style? (you should)
plt + theme_classic()

################################
# you could also write the prior code like so:
# plt = ggplot()
# plt + geom_point(aes(x = factor1, y = predicted.dependent, color = factor2), data = df.exclusion)
# plt + geom_line(aes(x = factor1, y = predicted.dependent, color = factor2), data = df.exclusion)
# this is only really useful if you want to plot from different data variables
# e.g. the lines are from one dataset and the points from another
# other than that ggplot is super easy, want to add error bars?
# plt + geom_errorbars(aes(ymin = predicted.dependent - se, ymax = predicted.dependent + se))


# 7. ???

# 8. profit