SaltHiera
=========

[![Build Status](https://travis-ci.org/Gtmtechltd/salthiera.png?branch=master)](https://travis-ci.org/gtmtechltd/salthiera)

salthiera is a hiera-like tool which is designed to work with SaltStack Pillars via the ext_pillar option.

Background
----------

Hiera is a great way of defining conventions by which environmental data can be accessed. Unfortunately it is limited to specific lookup dictionary "keys", which you specify one at a time. This is incompatible with salt which expects an external pillar to supply a range of keys/values which it merges into its existing pillar information.

Therefore there was a need to create something which gives the convention advantages of the Hiera system which integrates well with SaltStack.

Initially this project is written in Ruby as a gem, however I intend to port to python to align with SaltStack properly when I get the time.

Setup
-----

### Installing salthiera

    $ gem install salthiera

### Copy the salthiera.py plugin to your salthiera external pillar directory. E.g.

    $ cp salt/pillar/salthiera.py /usr/lib/pymodules/python2.7/salt/pillar/salthiera.py

### Define your own salthiera.yaml configuration file. E.g.

    hierarchy:
      - yaml:environments/%{saltenv}/*.yaml
      - files:environemtns/%{saltenv}/files/**/*

### Use it to lookup data outside salt!

    $ salthiera -c /etc/salthiera.yaml key1=value1 key2=value

### Use it to lookup data inside salt!

    $ salt '*' pillar.get key1


Lots more documentation soon


Authors
-------

- [Geoff Meakin](http://github.com/gtmtech) - Author
