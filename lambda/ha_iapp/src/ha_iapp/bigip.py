from f5.bigip import ManagementRoot
from functools import wraps
from ha_iapp import validate

@validate({'ip': 'ip', 'user': 'str', 'pwd': 'str'})
def client(ip='', user='admin', pwd=''):
    """
    create a BIG-IP client to run commands against
    """
    return ManagementRoot(ip, user, pwd)

@validate({'bigip': 'bigip', 'tmsh_cmd': 'str'})
def run_tmsh_cmd(bigip='', tmsh_cmd=''):
    """
    Run a TMSH command against the provided bigip object
    """
    return  bigip.tm.sys.config.exec_cmd(tmsh_cmd)

@validate({'bigip': 'bigip', 'bash_cmd': 'str'})
def run_bash_cmd(bigip='', bash_cmd=''):
    """
    Run a Bash command against the provided bigip object
    """
    res = bigip.tm.util.bash.exec_cmd('run', utilCmdArgs=f'-c "{bash_cmd}"')

    # determine if there was output from the command
    if 'commandResult' in res.__dict__:
        return res.commandResult
    else:
        return True

@validate({'bigip': 'bigip', 'url': 'str'})
def install_iapp(bigip='', url=''):
    """
    download and install an iApp
    """
    bash_cmd = f'curl {url} -o /config/cloud/aws/{url.split("/")[-1]}'
    download_res = run_bash_cmd(bigip, bash_cmd)

    load_cmd = f'tmsh load sys application template /config/cloud/aws/{url.split("/")[-1]}'
    load_res = run_bash_cmd(bigip, bash_cmd)
    
    return load_res

@validate({'bigip': 'bigip', 'iapp_name': 'str', 'route_table_id': 'str', 'interface': 'str'})
def cfg_ha_iapp(bigip='', iapp_name='', route_table_id='', interface=''):
    """
    configure the BIG-IP AWS HA iApp
    """
    cfg_cmd = f'tmsh create /sys application service aws_HA template {iapp_name} tables add {{ subnet_routes__cidr_blocks {{ column-names {{ route_table_id dest_cidr_block }} rows {{ {{ row {{ "{route_table_id}" "0.0.0.0/0" }} }} }} }} }} variables add {{ subnet_routes__route_management {{ value yes }}, subnet_routes__interface {{ value {interface} }}  }}'
    return run_bash_cmd(bigip, cfg_cmd)