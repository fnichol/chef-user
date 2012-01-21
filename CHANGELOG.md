## 0.2.11 (unreleased)


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
[@nessche]: https://github.com/nessche
