# Projector

A simple command-line app to keep your projects directory up to date with all of your Github projects.  I got tired of having to re-clone new projects all the time, and figured there had to be an easier way.  Turns out there wasn't, so I built one.

## Dependencies

Requires the [Thor](https://github.com/wycats/thor) and JSON gems.  You'll also need a Github account and API key.

## Installation and Usage

Install the gem:

    gem install projector

Configure your Github settings (if you haven't done so already).  Details are [here](http://help.github.com/set-your-user-name-email-and-github-token/), but the short version is:

    git config --global github.user <username>
    git config --global github.token <token>

Configure your working directory.  I have a `Projects` directory under my home directory where I keep all of my working copies.  Adjust to your own convention as needed.

    git config --global projector.workingdir ~/Projects

Run `projector update`.  Projector will find all of the repos you have access to and prompt you to clone them under your working directory if they're not already cloned.  By default, it will create a nested directory structure based on the repository owner, something like this:

    jayzes/
    jayzes/projector
    jayzes/cucumber-api-steps
    gvarela/
    gvarela/food_court_recipes

If you want it to forge ahead and clone everything, there's a `-y` option that assumes yes to every clone confirmation and doesn't bother prompting.

## Future Ideas
* Skiplist/repo ignore regexes
* Checking for repos that aren't under version control and prompting to create or prune them
* An easier way to run this under cron

# Author
Jay Zeschin

## Copyright

Copyright (c) 2011 Jay Zeschin. Distributed under the MIT License.
