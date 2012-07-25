## 0.3.1 (unreleased)


## 0.3.0 (July 24, 2012)

### Improvements

* Rename data_bag attribute to data_bag_name which works with bag_config cookbook. ([@fnichol][])


## 0.2.15 (July 24, 2012)

### Improvements

* Add :user_array_node_attr attribute which can override the location of the users' array in your node's attribute hash. ([@fnichol][])


## 0.2.14 (July 24, 2012)

### Improvements

* Pull request [#11](https://github.com/fnichol/chef-user/pull/11), Issue [#10](https://github.com/fnichol/chef-user/issues/10): Groups management (not only gid). ([@smaftoul][])


## 0.2.12 (May 1, 2012)

### Bug fixes

* user_account LWRP now notifies when updated (FC017). ([@fnichol][])
* Add plaform equivalents in default attrs (FC024). ([@fnichol][])

### Improvements

* Add unit testing for user_account resource. ([@fnichol][])
* Add unit testing for attributes. ([@fnichol][])
* Add TravisCI to run test suite and Foodcritic linter. ([@fnichol][])
* Reorganize README with section links. ([@fnichol][])
* Pull request [#7](https://github.com/fnichol/chef-user/pull/7): Fix semantic issues in README. ([@nathenharvey][])


## 0.2.10 (January 20, 2012)

### Bug fixes

* Pull request [#6](https://github.com/fnichol/chef-user/pull/6): Fix ordering of user deletion in :remove action. ([@nessche][])

### Improvements

* Issue [#4](https://github.com/fnichol/chef-user/issues/4): Support Ruby 1.8.6 (no #end_with?). ([@fnichol][])
* Issue [#3](https://github.com/fnichol/chef-user/issues/3): Mention dependency on ruby-shadow if managing password. ([@fnichol][])
* Issue [#5](https://github.com/fnichol/chef-user/issues/5): Clarify iteration through node['users'] in recipe[user::data_bag]. ([@fnichol][])


## 0.2.8 (January 20, 2012)

### Improvements

* Handle user names with periods in them. ([@fnichol][])


## 0.2.6 (October 18, 2011)

### Improvements

* Data bag item attribute `username` can override `id` for users with illegal data bag characters. ([@fnichol])


## 0.2.4 (September 19, 2011)

### Bug fixes

* Fix data bag missing error message. ([@fnichol][])


## 0.2.2 (September 14, 2011)

### Bug fixes

* Issue [#2](https://github.com/fnichol/chef-user/issues/2): user_account resource should accept String or Integer for uid attribute. ([@fnichol][])
* Add home and shell defaults for SuSE. ([@fnichol][])

### Improvements

* Add installation instructions to README. ([@fnichol][])
* Add fallback default `home_root` attribute value of "/home". ([@fnichol][])


## 0.2.0 (August 12, 2011)

The initial release.

[@fnichol]: https://github.com/fnichol
[@nathenharvey]: https://github.com/nathenharvey
[@nessche]: https://github.com/nessche
[@smaftoul]: https://github.com/smaftoul
