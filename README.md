SaltHiera
=========

[![Build Status](https://travis-ci.org/Gtmtechltd/salthiera.png?branch=master)](https://travis-ci.org/Gtmtechltd/salthiera)

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

### Define a salthiera.yaml configuration file

    $ chown -R puppet:puppet /etc/puppet/secure/keys
    $ chmod -R 0500 /etc/puppet/secure/keys
    $ chmod 0400 /etc/puppet/secure/keys/*.pem
    $ ls -lha /etc/puppet/secure/keys
    -r-------- 1 puppet puppet 1.7K Sep 24 16:24 private_key.pkcs7.pem
    -r-------- 1 puppet puppet 1.1K Sep 24 16:24 public_key.pkcs7.pem

### Use it to lookup data!

    $ salthiera -c /etc/salthiera.yaml key1=value1 key2=value

SaltHiera supports keys, values


Authors
-------

- [Geoff Meakin](http://github.com/gtmtech) - Author
