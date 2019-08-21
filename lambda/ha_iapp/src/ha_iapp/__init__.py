import ipaddress

def validate(*expected_args):
    def decorator(f):
        def wrapper(*args, **kwargs):
            i = 0
            for arg in args:
                if expected_args[i] == str:
                    validate_string(arg, 'String')
                elif expected_args[i] == 'ip':
                    validate_ipaddress(arg, 'IP Address')
                elif expected_args[i] == 'bigip':
                    validate_bigip(arg, 'BIG-IP')
                else:
                    raise AttributeError(f'unsupported attribute type')
                i += 1
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


# def valid_bigip(f):
#     def wrapper(*args, **kwargs):
#         try:
#             list(args)[0].raw()
#         except:
#             raise AttributeError(f'a valid BIG-IP ManagementRoot object is required')

#         return f(*args, **kwargs)
#     return wrapper

# def valid_ip(f):
#     pass

# def valid_string(attr_name, location, msg, empty_allowed=False):
#     def decorator(f):
#         def wrapper(*args, **kwargs):
#             for arg in args:
#                 print(f'TEST: {arg}')
#                 if not arg:
#                     raise AttributeError(f'a valid {msg} is required')
#             return f(*args, **kwargs)
#         return wrapper
#     return decorator