import tempfile
import pytest
import boto3
from botocore.stub import Stubber
from ha_iapp import password

@pytest.fixture
def infile():
    f = tempfile.TemporaryFile()
    f.write(b'{"password": "abc123"}')
    f.seek(0)
    return f

def test_get(infile):
    """
    Read password from S3 file
    """
    client = boto3.client('s3')
    stubber = Stubber(client)
    get_object_response = {'Body': infile}
    expected_params = {'Bucket': 'bucket', 'Key': 'credentials/master'}
    stubber.add_response('get_object', get_object_response, expected_params)
    stubber.activate()
    pwd = password.get(client, 'bucket')
    assert pwd == 'abc123'

def test_get_without_client():
    
    with pytest.raises(AttributeError):
        password.get('', 'bucket')
    
def test_get_without_buciket():
    pass
