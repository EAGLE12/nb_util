
<h1>Table of Contents<span class="tocSkip"></span></h1>
<div class="toc" style="margin-top: 1em;"><ul class="toc-item"><li><span><a href="#Name" data-toc-modified-id="Name-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>Name</a></span></li><li><span><a href="#Summary" data-toc-modified-id="Summary-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>Summary</a></span></li><li><span><a href="#Installation" data-toc-modified-id="Installation-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Installation</a></span></li><li><span><a href="#Usage" data-toc-modified-id="Usage-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>Usage</a></span></li><li><span><a href="#Uninstall" data-toc-modified-id="Uninstall-5"><span class="toc-item-num">5&nbsp;&nbsp;</span>Uninstall</a></span></li><li><span><a href="#Development" data-toc-modified-id="Development-6"><span class="toc-item-num">6&nbsp;&nbsp;</span>Development</a></span></li><li><span><a href="#Contributing" data-toc-modified-id="Contributing-7"><span class="toc-item-num">7&nbsp;&nbsp;</span>Contributing</a></span></li><li><span><a href="#License" data-toc-modified-id="License-8"><span class="toc-item-num">8&nbsp;&nbsp;</span>License</a></span></li><li><span><a href="#Code-of-Conduct" data-toc-modified-id="Code-of-Conduct-9"><span class="toc-item-num">9&nbsp;&nbsp;</span>Code of Conduct</a></span></li></ul></div>

# Name

nb_util

# Summary

nb_util allows you to generate latex(tex) format from your jupyter notebook(ipynb) format.

This gem supplies to help when you use jupyter notebook. 

what can it help me?

1. Convert [my_help](https://github.com/daddygongon/my_help) to jupyter notebook(ipynb)
1. Combine multiple jupyter notebook into one jupyter note book
1. Extract data from jupyter notebook, then convert to the file format you extracted data.
1. To see jupyter notbook's contents
1. Convert jupyter notebook(ipynb) to latex(tex) format(thesis and handout(A4))


# Installation

Add this line to your application's Gemfile:

```ruby
gem 'nb_util'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nb_util
    
To use this library:

```ruby
require 'nb_util'
```

On your local system, run the following in your command line: 

    $ git clone git@github.com:EAGLE12/nb_util.git
    $ cd nb_util
    $ bundle update
    
Run the following in your command line:

    $ bundle exec exe/nb_util

```ruby
nb_util says hello, EAGLE !!
Commands:
  nb_util combine [input file1] [input file2] [output filename]  # combine file1 and file2
  nb_util getcode [filename]                                     # save in ruby format
  nb_util help [COMMAND]                                         # Describe available commands or one specific command
  nb_util iputs [filename]                                       # display ipynb file contents
  nb_util ipynb2tex [filename] [option]                          # convert ipynb to tex's thiesis format
  nb_util red WORD [OPTION]                                      # red words print.
  nb_util yaml2ipynb [input filename]                            # convert yaml to ipynb
```

Have a good life with nb_util!

# Usage

```
$ nb_util
```

```ruby
nb_util says hello, EAGLE !!
Commands:
  nb_util combine [input file1] [input file2] [output filename]  # combine file1 and file2
  nb_util getcode [filename]                                     # save in ruby format
  nb_util help [COMMAND]                                         # Describe available commands or one specific command
  nb_util iputs [filename]                                       # display ipynb file contents
  nb_util ipynb2tex [filename] [option]                          # convert ipynb to tex's thiesis format
  nb_util red WORD [OPTION]                                      # red words print.
  nb_util yaml2ipynb [input filename]                            # convert yaml to ipynb
```

# Uninstall

```
$ gem uninstall nb_util
```
And then

You want to uninstall by filling number on it

```ruby
Select gem to uninstall:
 1. nb_util-0.3.4
 2. nb_util-0.3.5
 3. nb_util-0.3.6
 4. nb_util-0.3.7
 5. nb_util-0.3.8
 6. nb_util-0.4.0
 7. All versions
> 7
Successfully uninstalled nb_util-0.3.4
Successfully uninstalled nb_util-0.3.5
Successfully uninstalled nb_util-0.3.6
Successfully uninstalled nb_util-0.3.7
Successfully uninstalled nb_util-0.3.8
Remove executables:
	nb_util

in addition to the gem? [Yn]  y
Removing nb_util
Successfully uninstalled nb_util-0.4.0
```
 

# Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org/gems/nb_util).

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/EAGLE12/nb_util. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

1. Fork it (https://github.com/EAGLE12/nb_util/fork)
1. Create your feature branch (git checkout -b my-new-feature)
1. Commit your changes (git commit -am 'Added some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create new Pull Request

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

# Code of Conduct

Everyone interacting in the NbUtil project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/EAGLE12/nb_util/blob/master/CODE_OF_CONDUCT.md).


```ruby

```
