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
The `script_config` file will allow you to customize versions, personal information, and default directories.

Install
-------

Clone the repo to your home directory:

```git clone git@git.malauzai.com:infrastructure/laptop-setup.git```


Review the scripts to see what you need (avoid running scripts you haven't read!)

Execute the entire setup script:

```sh master_setup 2>&1 | tee ~/laptop.log```

Optionally, run individual scripts based on your needs (All scripts need to be run from the root directory):

Ex: To install NVM and Node

```sh scritps/nvm_node.sh 2>&1 | tee ~/laptop.log```


Individual Script Info
========================

mac_init.sh
---------------
This will install the basic tools and libraries needed for basic devlopment.

**Other scripts are dependant on these libraries so this should always be run first.**


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

git_config.sh
--------------------
* Sets your git config global username and email.
* Installs a git helper tool

* [git-credential-osxkeychain]() credential helper to tell Git to remember your username and password every time it talks to Gitlab. (Not critical, we should be using SSH not HTTPS to talk to Gitlab)

ssh_agent_rsa_key.sh
-----------------
* Creates an id_rsa ssh key
* Also installs some ssh-agent.

* [ssh-agent]() a helper program that keeps track of user's identity keys and their passphrases.

postgres_database_setup.sh
---------------
* Configures postgres to run on startup and creates default postgres user and database `first.last`.
* Also adds `pg_start` and `pg_stop` alias to your bash_profile to start and stop postgres.

rbenv_ruby_rails.sh
---------------
Installs a ruby version manager, ruby, and rails.
Also updates your bash_profile path to add rbenv to your PATH.

* [NVM]() simple and powerful ruby version manager (Not compatible with RVM)
* [ruby]() installs ruby, you can specify the version in the script_config file
* [rails]() installs rails, you can specify the version in the script_config file

nvm_node.sh
---------------
Installs a node version manager and node.
Also updates your bash_profile path to add NVM to your PATH.

* [NVM]() Node Version Manager
* [node]() installs node, you can specify the version in the script_config file

bash_aliases_functions.sh
---------------
* This adds helpful aliases and functions to your `bash_profile`


Developer Tools
================
A collection of programs, tools, and packages that I install on every machine.
These are all installed via Homebrew

These will only be installed if you pass the option `dev_tools` to `sh master_setup`
 ```
 sh master_setup dev_tools
 ```
* [Flycut]() Flycut is a clean and simple clipboard manager for developers.
* [Spectacle]() Spectacle allows you to organize your windows without using a mouse.
* [iTerm2]() iTerm2 is a replacement for Terminal and the successor to iTerm.
* [TablePlus]() Modern, native client with intuitive GUI tools to create, access, query & edit multiple relational databases
* [Docker]() Docker is a tool designed to make it easier to create, deploy, and run applications by using containers.
* [Apptivate]() With Apptivate, you can create global hotkeys to: Launch, activate, hide and quick peek applications; Execute scripts; Run Automator workflows; Instantly access Files and Folders.
* [Google Chrome]() Google Chrome is a cross-platform web browser developed by Google.
* [Visual Studio Code]() Visual Studio Code is a code editor redefined and optimized for building and debugging modern web and cloud applications.
* [Postman]() Simplify workflows and create better APIs – faster – with Postman, a collaboration platform for API development.
* [Evernote]() Evernote is an app designed for note taking, organizing, task management, and archiving.
* [Fork]() A fast and friendly git client for Mac and Windows.
* [aText]() aText accelerates your typing by replacing abbreviations with frequently used phrases you define.
* [Itsycal]() Itsycal is a tiny calendar for your Mac’s menu bar.



Malauzai specific scripts
=========================

These scripts are to install Malauzai repos, applications, and applicable settings.

They are all located in the `scripts/malauzai` directory

bash_aliases_functions.sh
---------------
* This adds helpful aliases and functions to your `bash_profile`

clone_adapters.sh
---------------
* This will get a current list of all of our adapters from preproduction and then clone them locally.
* Creates a root directory based on the path specified in `script_config` to store all malauzai git repos

sami_setup.sh
---------------
* Creates a root directory based on the path specified in `script_config` to store all malauzai git repos
* Installs three custom gems SAMI depends on
  1. malauzai-soap4r
  2. wkhtmltoimage-binary
  3. wkhtmltopdf-binary
* Clones SAMI repo
* Creates the following gitignored files with no sensitive information
  1. database.yml
  2. app_config.yml
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
