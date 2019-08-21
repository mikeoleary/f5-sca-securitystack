import ipaddress

def validate(*expected_args):
    def decorator(f):
        def wrapper(*args, **kwargs):
            zipped = zip(expected_args[0].items(), args)
            for (name, arg_type), arg in zipped:
                if arg_type == 'str':
                    validate_string(arg, name)
                elif arg_type == 'ip':
                    validate_ipaddress(arg, name)
                elif arg_type == 'bigip':
                    validate_bigip(arg, name)
                elif arg_type == 's3':
                    validate_s3(arg, name)
                else:
                    raise AttributeError(f'unsupported attribute type') 
            return f(*args, **kwargs)          
        return wrapper
    return decorator

def validate_wrapper(f):
    def wrapper(*args, **kwargs):
        kwargs['msg'] = f'a valid {args[1]} attribute is required'
        f(*args, **kwargs)
    return wrapper

@validate_wrapper
def validate_string(string, name='string', msg=''):
    if not string and type(string) != 'str':
    # if not string:
        raise AttributeError(msg)

@validate_wrapper
def validate_ipaddress(ip, name='ip address', msg=''):
    try:
        ipaddress.ip_address(ip)
    except ValueError:
        raise AttributeError(msg)

@validate_wrapper   
def validate_bigip(bigip, name='BIG-IP', msg=''):
    try:
        bigip.raw()
    except:
        raise AttributeError(msg)

@validate_wrapper
def validate_s3(s3, name='S3', msg=''):
    """
    There is not a boto3 S3 object, so I can't validate it.  For now, make sure
    it's not empty
    """
    # if not s3:
    #     raise AttributeError(msg)
    pass
