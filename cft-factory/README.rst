cft-factory
=======

Python funtions to generate Cloudformation Templates.

Development
-----------

1. Ensure ``Python3`` is installed as well as ``pip3``
2. Clone repository: ``git@github.com:mikeoleary/f5-sca-securitystack.git``
3. Install dev dependencies ``make install``
4. Activate virtualenv: ``pipenv shell``
5. Add your python file to the cft and validate sections of the makefile:

Running Validation Tests
-------------

Run tests locally using ``make cft && make validate`` if virtualenv is active:

::

    $ make cft && make validate

