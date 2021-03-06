import pytest
import mock
from f5_sca_libs import bigip
from f5.bigip import ManagementRoot
from icontrol.session import iControlRESTSession


class MockManagementRoot(ManagementRoot):
    class tm():
        class sys():
            class config():
                def exec_cmd(cmd):
                    return '{"result": "True"}'
        class util():
            class bash():
                def exec_cmd(action, utilCmdArgs):
                    class output:
                        commandResult = '{"result": True")'
                    result = output()
                    return result
    def raw():
        return '{"result": "True"}'

@pytest.fixture
def fakebigip():
    mocker = mock.MagicMock(wraps=MockManagementRoot)    
    return mocker

# ----------- BIG-IP Client ---------------------
def test_client(mocker):
    mocker.patch('f5_sca_libs.bigip.ManagementRoot')
    # create a big-ip client
    client = bigip.client('192.168.100.100', 'admin', 'admin123')
    bigip.ManagementRoot.assert_called_with('192.168.100.100', 'admin', 'admin123')

def test_client_without_ip():
    with pytest.raises(AttributeError):
        client = bigip.client('', 'admin', 'admin123')

def test_client_without_pwd():
    with pytest.raises(AttributeError):
        client = bigip.client('192.168.100.100', 'admin', '')

def test_client_with_invalid_ip():
    with pytest.raises(AttributeError):
        client = bigip.client('1.1.1.1.1', 'admin', 'admin123')

# ----------- Run TMSH Command ---------------------        
def test_run_tmsh_cmd_with_invalid_bigip():
    with pytest.raises(AttributeError):
        bigip.run_tmsh_cmd('bigip', 'show /ltm virtual')

def test_run_tmsh_cmd_without_tmsh_cmd(fakebigip):
    with pytest.raises(AttributeError):
        bigip.run_tmsh_cmd(fakebigip, '')

def test_run_tmsh_cmd(fakebigip):
    res = bigip.run_tmsh_cmd(fakebigip, 'show /ltm virtual')
    fakebigip.tm.sys.config.exec_cmd.assert_called_with('show /ltm virtual')
    assert res == '{"result": "True"}'

# ----------- Run Bash Command ---------------------
def test_run_bash_cmd_without_bigip():
    with pytest.raises(AttributeError):
        bigip.run_bash_cmd('bigip', 'echo')

def test_run_bash_cmd_without_bash_cmd(fakebigip):
    with pytest.raises(AttributeError):
        bigip.run_bash_cmd(fakebigip, '')

def test_run_bash_cmd(fakebigip):
    res = bigip.run_bash_cmd(fakebigip, 'netstat -rn')
    fakebigip.tm.util.bash.exec_cmd.assert_called_with('run', utilCmdArgs='-c "netstat -rn"')

# ----------- Install HA iApp ---------------------
def test_install_iapp(fakebigip):
    url = 'https://raw.githubusercontent.com/F5Networks/f5-aws-cloudformation/v3.1.0/iApps/f5.aws_advanced_ha.v1.4.0rc3.tmpl'
    res = bigip.install_iapp(fakebigip, url)
    assert res == True


# ----------- CFG HA iApp ---------------------
def test_cfg_ha_iapp_without_bigip():
    with pytest.raises(AttributeError):
        bigip.cfg_ha_iapp('bigip', 'f5.aws_advanced_ha.v1.4.0rc3', 'r123456789', '/Common/internal')

def test_cfg_ha_iapp_without_iapp_name(fakebigip):
    with pytest.raises(AttributeError):
        bigip.cfg_ha_iapp(fakebigip, '', 'r123456789', '/Common/internal')

def test_cfg_ha_iapp_without_route_table_id(fakebigip):
    with pytest.raises(AttributeError):
        bigip.cfg_ha_iapp(fakebigip, 'f5.aws_advanced_ha.v1.4.0rc3', '', '/Common/internal')

def test_cfg_ha_iapp_without_interface(fakebigip):
    with pytest.raises(AttributeError):
        bigip.cfg_ha_iapp(fakebigip, 'f5.aws_advanced_ha.v1.4.0rc3', 'r123456789', '')

def test_cfg_ha_iapp(fakebigip):
    iapp_name = 'f5.aws_advanced_ha.v1.4.0rc3'
    route_table_id = 'r123456789'
    interface = '/Common/internal'
    res = bigip.cfg_ha_iapp(fakebigip, iapp_name, route_table_id, interface)
    fakebigip.tm.util.bash.exec_cmd.assert_called_with('run', utilCmdArgs='-c "tmsh create /sys application service aws_HA template f5.aws_advanced_ha.v1.4.0rc3 tables add { subnet_routes__cidr_blocks { column-names { route_table_id dest_cidr_block } rows { { row { "r123456789" "0.0.0.0/0" } } } } } variables add { subnet_routes__route_management { value yes }, subnet_routes__interface { value /Common/internal }  }"')
    assert res == True