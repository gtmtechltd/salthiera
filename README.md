SaltHiera
=========

salthiera is a hiera-like tool which is designed to work with SaltStack Pillars via the ext_pillar option.

Background
----------

Hiera is a great way of defining conventions by which environmental data can be accessed. Unfortunately it is limited to specific lookup dictionary "keys", which you specify one at a time. This is incompatible with salt which expects an external pillar to supply a range of keys/values which it merges into its existing pillar information.

Therefore there was a need to create something which gives the convention advantages of the Hiera system which integrates well with SaltStack.

Initially this project is written in Ruby as a gem, however I intend to port to python to align with SaltStack properly when I get the time.

Setup
-----

#### Installing salthiera

    (on saltmaster only)

    $ gem install salthiera


#### Define a /etc/salt/salthiera.yaml configuration file

    ---
    hierarchy:
      - yaml:/srv/salt/environments/%{saltenvironment}/*.yaml.%{id}   # e.g. production/haproxy.yaml.dmzserver01
      - yaml:/srv/salt/environments/%{saltenvironment}/*.yaml         # e.g. production/haproxy.yaml
      - yaml:/srv/salt/environments/common/*.yaml                     # e.g. common/haproxy.yaml
      - files:/srv/salt/environments/%{saltenvironment}/files/**/*
      - files:/srv/salt/environments/common/files/**/*
      - eyaml:/srv/salt/environments/%{saltenvironment}/**/*.eyaml
      - eyaml:/srv/salt/environments/common/**/*.eyaml
      - efiles:/srv/salt/environments/%{saltenvironment}/efiles/**/*
      - efiles:/srv/salt/environments/common/efiles/**/*

Items that appear earlier in the hierarchy override items that appear later in the hierarchy. 

In the above hierarchy (defined in salthiera.yaml), the specific environment YAML (parameterised as %{saltenvironment} always overrides the common environment YAML, because it is referenced earlier in the hierarchy section. 

The hierarchy supports YAML files (prefixed with yaml:), EYAML files which are encrypted yaml files (prefixed with eyaml:), and raw files (which might contain public SSL certs, prefixed with files:), and encrypted raw files (which might contain private SSL keys, prefixed with efiles:). 

#### Put some example YAML files together (representing your environment-based data)

/srv/salt/environments/production/example.yaml

    ---
    my_string: I am the production value
    
/srv/salt/environments/common/example.yaml

    ---
    my_string: I am the common value
    default_string: I am the common default value

#### Use salthiera on the saltmaster to lookup data on the commandline!

(saltmaster)

    $ salthiera -c /etc/salt/salthiera.yaml key1=value1 key2=value

e.g.

    $ salthiera -c /etc/salt/salthiera.yaml saltenvironment=production id=dmzserver01

(the keys and values you supply relate directly to the %{} delimeters in your salthiera.yaml config file (above)

#### Configure salt to do this automatically as part of its external pillar processes:

/etc/salt/master configuration file for saltmaster

    ...
    ext_pillar:
      - salthiera: /etc/salt/salthiera.yaml
    ...

    #pillar_roots:  (comment this out unless you want to use pillar in conjunction with salthiera)

#### Copy the salthiera.py file in this repos salt/pillar directory into salts pymodules (will depend on your python version and install location)

    $ cp salt/pillar/salthiera.py /usr/share/pyshared/salt/pillar/salthiera.py
    $ ln -s /usr/share/pyshared/salt/pillar/salthiera.py /usr/lib/pymodules/python2.7/salt/pillar/salthiera.py

#### Configure a salt minion with its environment

    # /etc/salt/minion config file

    ...
    grains:
      saltenvironment: production    # different on different environments
    ...

#### Test on the minion

    $ salt-call pillar.get my_string
    > I am the production value

    $ salt-call pillar.get default_string
    > I am the common default value

In this way you can manage key-value pairs, using YAML, or entire files which makes it easier to manage keys, binary files etc.

Encryption
==========

Salthiera support encrypting using the PKCS7 encryption format. Salthiera has a "sister" project for puppet called hiera-eyaml, which we will use on our local machine to manage the encryption. Hiera-eyaml does not need to be installed anywhere else.

#### Generate keys for encrypting stuff LOCALLY (if you dont want to do this, then bypass this section)

    (on your local desktop)

    $ gem install hiera-eyaml
    $ cd /tmp
    $ eyaml createkeys         # keys will be created in a keys/ subdirectory
    $ ls keys/
      private_key.pkcs7.pem  public_key.pkcs7.pem

#### Encrypt a sensitive password like this

    $ eyaml encrypt --pkcs7-public-key keys/public_key.pkcs7.pem -s "SOME STRING TO ENCRYPT"
      ENC[PKCS7,..........]
   
 Copy this ENC string into any .eyaml file in your salt git repo (environments data)

  /srv/salt/environments/production/database.eyaml

    ---
    database_password: ENC[PKCS7,............]

You would typically generate different keys for different environments and use the correct environments keys to generate encrypted data for that environment. 

Hiera-eyaml toolset allows you to do a lot of things, for example you can interactively edit an .eyaml file using vi, replacing the encrypted tokens in realtime. For further information see the hiera-eyaml project to see all the possibilities available to you

When done, copy the public_key.pkcs7.pem into your salt git repo somewhere nice (you can publish this to your dev team)

#### Set up the salt-master to decrypt the values
 
Copy the public and private keys you generated above into your saltmaster in a secure place:

(on your saltmaster)

    $ mkdir -p /etc/salt/salthiera/keys
    $ chown -R root:root /etc/salt/salthiera/keys
    $ chmod -R 0500 /etc/salt/salthiera/keys

Edit /etc/salt/salthiera.yaml and add:

    eyaml_public_key: /etc/salt/salthiera/keys/public_key.pkcs7.pem
    eyaml_private_key: /etc/salt/salthiera/keys/private_key.pkcs7.pem

Ensure keys directory exists
       
    $ chmod 0400 /etc/salt/salthiera/keys/*.pem
    $ ls -lha /etc/salt/salthiera/keys
    -r-------- 1 root   root   1.7K Sep 24 16:24 private_key.pkcs7.pem
    -r-------- 1 root   root   1.1K Sep 24 16:24 public_key.pkcs7.pem

You need a public key and a private key to decrypt a value, but only a public to encrypt a value. In this way, you can distribute your public key to your dev team so they are able to encrypt values and commit them to your salt git repo, and only the saltmaster itself can decrypt the value. This allows you to commit production data alongside your vagrant/dev/staging data in the same repo in safe way.

TROUBLESHOOTING
---------------

If for some reason salt isnt returning ANY values (either plaintext or encyrpted), but salthiera commandline lookups executed properly as explained above is, then the chances are that salt cannot find the "salthiera" binary that comes with this gem. If so, alter the salt.utils.which value in /usr/share/pyshared/salt/pillar/salthiera.py that refers to the salthiera binary and supply the fully qualified path to the salthiera binary (and likewise lower in the code too). This will fix this problem.

Authors
-------

- [Geoff Meakin](http://github.com/gtmtech) - Author
