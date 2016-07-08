Scripts and configration to build Magic3 environment
====

Easily build Magic3 environment by Vagrant

## Description
auto generating the below environment by shell sciript in Vagrantfile

1. Create LAMP environment
1. Create database for sample
1. Download the latest Magic3 source archive


## Requirement

Vagrant is required.

- VirtualBox

https://www.virtualbox.org/wiki/Downloads

- Vagrant

https://www.vagrantup.com/downloads.html

## Usage

1. make work directory

    $ mkdir dirname

1. copy Vagrantfile in work directory

    $ cd dirname
    
    $ cp Vagrantfile ./

1. start building

    $ vagrant up

