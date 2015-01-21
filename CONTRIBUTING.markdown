### Making a release ###

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




