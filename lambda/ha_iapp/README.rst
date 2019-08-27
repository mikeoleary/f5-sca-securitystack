ha_iapp
=======

Lambda function to install and configure the F5 BIG-IP AWS HA iApp for a BIG-IP devices service cluster.

Development
-----------

1. Ensure ``Python3`` is installed as well as ``pip3``
2. Clone repository: ``git@github.com:mikeoleary/f5-sca-securitystack.git``
3. Install dev dependencies ``make install``
4. Activate virtualenv: ``pipenv shell``

Building Lambda ZIP file
-------------------------

Zip the lambda function so it can be uploaded to AWS using ``make zip`` if virtualenv is active:

::

    $ make zip

If virtualenv isn't active then use:

::

    $ pipenv run make zip