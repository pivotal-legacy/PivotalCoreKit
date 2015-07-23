#Guidelines for Contributing to Pivotal Core Kit (PCK)

So, you want to add a new feature to `PivotalCoreKit` … great! Before you can start contributing to `PCK`, you'll need to do some [one-time set up](#one_time_setup) to do `PCK` development on your local machine.

##Checklist before submitting a pull request

Ensure that you have:  

* Created your feature on [a local branch](#create_feature_branch)
* Placed your feature in [the correct PCK module](#where_feature_lives)
* Written [good tests](#writing_feature_tests) for your feature
* [Run all of PCK's tests](#run_all_pck_tests) to confirm that no existing features have regressed
* [Added your feature to the CHANGES file](#editing_changes_authors)

## An example feature

Let's say we are developing a category for `NSString` instances that returns a
new string transformed into [Pig Latin](https://en.wikipedia.org/wiki/Pig_Latin).  If we used this category in our production code like this:

```
NSString *originalString = @"connecticut is great";
NSString *pigLatinString = [@"connecticut is great" asPigLatin];

NSLog(@"original string: '%@'", originalString);
NSLog(@"pig latin string: '%@'", pigLatinString);
```

we would expect console output like this:

```
> original string: 'connecticut is great'
> pig latin string: 'onnecticutcay isway eatgray'
```

Now that we have defined our feature, we can begin adding it to `PCK`.

##<a name="create_feature_branch"></a>Create a feature branch

Start by creating a new local branch for the feature.

In our Pig Latin example, we would start by creating a new feature branch like this:

```
git checkout -b add-pig-latin-category-to-nsstring
```

##<a name="where_feature_lives"></a>Determine where your feature should live in Pivotal Core Kit

`PCK` is actually a collection of several different Xcode projects which extend Apple frameworks (like `Foundation`, `UIKit`, `CoreLocation`, etc). Each Xcode project lives inside a folder with the same name as the Apple framework it extends.  For more information about `PCK`'s organization, refer to the project [README](README.markdown).

In our Pig Latin example above, we are writing a category on `NSString`, which is declared in Apple's `Foundation` framework.  Since our category is meant to be used in production code we would want to put this feature in `Foundation+PivotalCore`.

So we would declare the public methods for our feature in:

[Foundation/Core/Extensions/NSString+PivotalCore.h](https://github.com/pivotal/PivotalCoreKit/blob/master/Foundation/Core/Extensions/NSString+PivotalCore.h)

We would add the production implementation of our feature in:

[Foundation/Core/Extensions/NSString+PivotalCore.m](https://github.com/pivotal/PivotalCoreKit/blob/master/Foundation/Core/Extensions/NSString+PivotalCore.m)

And we would add tests for our feature to:

[Foundation/Spec/Extensions/NSStringSpec+PivotalCore.mm](https://github.com/pivotal/PivotalCoreKit/blob/master/Foundation/Spec/Extensions/NSStringSpec%2BPivotalCore.mm)




##<a name="writing_feature_tests"></a>Writing tests for a PCK feature

`PCK` tests are written using [Cedar](https://github.com/pivotal/cedar), an open source [BDD](https://en.wikipedia.org/wiki/Behavior-driven_development) testing framework for Objective-C developed at Pivotal Labs.  You can find out more about writing cedar tests on the [cedar wiki](https://github.com/pivotal/cedar/wiki).

A good cedar test for our Pig Latin feature might start like this:

```

describe(@"turning a string into Pig Latin", ^{

  it(@"should transform words beginning with one consonant", ^{
      [@"connecticut" asPigLatin] should equal(@"onnecticutcay");
  });

  it(@"should transform words beginning with a vowel", ^{
      [@"ohio" asPigLatin] should equal(@"ohioway");
  });

  it(@"should transform words beginning with two consonants", ^{
      [@"great" asPigLatin] should equal(@"eatgray");
  });

  // etc.
};


```

##<a name="run_all_pck_tests"></a>Running all PCK tests

Before submitting your pull request, you should run all of PCK's tests to make sure your feature hasn't broken anything.  To run all the PCK specs, simply navigate to the PCK project root and run the following rake command from the terminal:

```
rake all:spec
```

##<a name="editing_changes_authors"></a>Editing the CHANGES file
Along with the code for your feature, you should also edit the [CHANGES](CHANGES.markdown) file to
note the changes you have made. This should be a succinct summary of your feature
under the section for the version labeled "in progress". Refer to the [CHANGES](CHANGES.markdown) file itself for examples.

##<a name="one_time_setup"></a>One time setup for PCK development
Let's get started making a fork of the `PivotalCoreKit` repository in your
own github account and cloning it to your development machine.

Before getting started, you might want to run the tests to ensure your
local copy of `PCK` is working and your development environment is set up
correctly.  You can run all of `PCK`'s tests by running the following commands
from the project root:

```
git submodule update --init
rake all:spec
```

Assuming that all the specs ran and passed, we're ready to begin developing
your new feature.

## Making a release (for PCK maintainers only)

After stories before a release marker in the backlog have been accepted by the PM and the next task in tracker is a release marker, it's time to create a release.

Here's the brief checklist for creating a new release version of PivotalCoreKit.

* Update `CHANGES.markdown` to include major new features, bug fixes, and API changes.

* Update `PivotalCoreKit.podspec` to advance the version number for the pod and the git tag it points to on github.

* When you've made those commits and are ready to tag, tag the project thusly: `git tag -a vx.x.x -m 'Refer to CHANGES.markdown for a list of changes in this release'`

* `git push origin head`

* `git push origin --tags`

* `pod spec lint` to ensure that there is no problem with the podspec.  If there are problems, you'll need to delete the tag from origin, fix the issue, and try again.

* Make a release in github that points to the tag

* `pod trunk push` to send the new version to cocoapods
