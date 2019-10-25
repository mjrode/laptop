Laptop
======

Laptop is a script to set up a macOS laptop for Rails development.

It can be run multiple times on the same machine safely.
It installs, upgrades, or skips packages
based on what is already installed on the machine.

It is broken up into multiple setup scripts to give you the flexibilty to pick what you want to setup.

Requirements
------------
It supports:

* macOS Mojave (10.14)

* assumes you are using bash

Older versions may work but aren't regularly tested.

Shell Script Config
----------
The `script_config` file will allow you to set your preferred values for package versions and install directory.

Install
-------

Clone the repo to your home directory:

```git clone git@git.malauzai.com:infrastructure/laptop-setup.git```


Review the scripts to see what you need (avoid running scripts you haven't read!)

Execute the entire setup script (Only recommended for fresh OSX installs):

```sh master_setup 2>&1 | tee ~/laptop.log```

Optionally, run individual scripts based on your needs:

Ex: Have ruby/rails but all tests are failing locally

```sh sh sami_setup 2>&1 | tee ~/laptop.log```


Individual Script Info
========================

aliases_functions
---------------
This adds helpful aliases and functions to your `bash_profile`


mac_malauzai
---------------
This install the basic tools and libraries needed for all other scripts.


macOS tools:

* [Homebrew]() for managing operating system libraries.
* [Xcode-command-line-tools]() system compiler for C++ ruby libraries

Unix tools:

* [Git]() for version control
* [OpenSSL]() for Transport Layer Security (TLS)
* [readline]() for command-line editing

Image tools:

* [ImageMagick]() for cropping and resizing images

Other tools and programs:

* [libyaml]() A C library for parsing and emitting YAML
* [coreutils]() GNU File, Shell, and Text utilitie
* [gnupg]() allows you to encrypt and sign your data and communications

Databases:

* [Postgres]() for storing relational data
* [Redis]() for storing key-value data

rbenv_setup
---------------
Installs a ruby version manager, ruby, and rails.
Also updates your bash_profile path to add rbenv to your PATH.

* [rbenv]() simple and powerful ruby version manager (Not compatible with RVM)
* [ruby]() installs ruby 2.4.3 (Unless version file is changed) which is what SAMI is currently on
* [rails]() installs rails 4.2.10 (Unless version file is changed) which is what SAMI is currently on

git_config_malauzai
--------------------
Sets your git config global username to use your finastra user name and email.
Installs a git helper tool

* [git-credential-osxkeychain]() credential helper to tell Git to remember your username and password every time it talks to Gitlab. (Not critical, we should be using SSH not HTTPS to talk to Gitlab)

ssh_key_config
---------------
Creates an id_rsa ssh key tied to your finastra email, and walks you through how to add this key to Jumpcloud and Gitlab (Required for SAMI)
Also installs some SSH tools.

Can pass run script with `sh ssh_key_config no_open` to stop the script from opening your browser to Jumpcloud and Gitlab.

* [ssh-agent]() a helper program that keeps track of user's identity keys and their passphrases.

database_setup
---------------
Configures postgres to run on startup and creates default postgres user and database `first.last`.
Also adds `pg_start` and `pg_stop` alias to your bash_profile to start and stop postgres.

sami_setup
---------------
* Creates root directory `mz` to store all malauzai git repos
* Installs three custom gems SAMI depends on
  1. malauzai-soap4r
  2. wkhtmltoimage-binary
  3. wkhtmltopdf-binary
* Clones SAMI repo into `~/mz/sami`
* Creates the following gitignored files with no sensitive information
  1. database.yml
  2. config.yml
  3. certificates and keys
* creates `sami_development` and `sami_test` database
* runs all migrations and seeds the database


Known Issues/FAQ
==================


Error when installing Ruby
---------------------------

```
You don't have write permissions for the /Library/Ruby/Gems/2.3.0 directory.
```

Changes to your bash_profile and PATH variable were not picked up correctly.
Typically closing all terminal windows and re-running the script will fix this.

Error when installing Rails
----------------------------

```
An error occurred while installing libxml-ruby (3.0.0), and Bundler cannot continue.
Make sure that `gem install libxml-ruby -v '3.0.0' --source 'https://rubygems.org/'` succeeds before bundling.

```
Try to run the following commands in your terminal and then rerun the script from the same terminal window.
```
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
```

```
brew install libxml2
```

```
export PATH="/usr/local/opt/libxml2/bin:$PATH"
```

End Result
-----------
At this point you should be able to run SAMI locally with no issues.
You should also be able to run the test suite `rake test:controllers` and have the results match preproduction.


Help Contribute and Keep up To Date
-------------------------------------
* Please reach out if there are any issues.
* As we upgrade to different Ruby and Rails versions this script will have to be updated.
* You can report issues on [GitLab](https://git.malauzai.com/infrastructure/laptop-setup) or slack me (mike.rode) directly.
