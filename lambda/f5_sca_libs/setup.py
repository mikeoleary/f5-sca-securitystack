from setuptools import setup, find_packages

with open ('README.rst', encoding='UTF-8') as f:
    readme = f.read()

setup(
    name = 'f5_sca_libs',
    version = '1.0.0',
    description = 'Deploy and configure the F5 BIG-IP AWS HA iApp',
    long_description = readme,
    author = 'Cody Green',
    author_email = 'c.green@f5.com',
    packages = find_packages('src'),
    package_dir = {'': 'src'},
    install_requires = []
)
