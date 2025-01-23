import requests

api_address = "http://192.168.0.111:7557" #IP Address Debian Server
ssid_Ke = "4",

def gantissid(data, ssid):
    print("acs:", data["sn"])
    try:
        parameter = {
            "name": "setParameterValues",
            "parameterValues": [
                [f"Device.WiFi.SSID.1.SSID", ssid, "xsd:string"]
            ]
        }
        response = requests.post(f'{api_address}/devices/{data["sn"]}/tasks?connection_request', json=parameter)
        print(response.status_code)
        print(response.json())
        return response.status_code
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
        return 500

def gantipw(data, password):
    print("acss:", data["sn"])
    try:
        parameter = {
            "name": "setParameterValues",
            "parameterValues": [
                [f"Device.WiFi.AccessPoint.1.Security.KeyPassphrase.{ssid_Ke}.PreSharedKey.1.PreSharedKey", password, "xsd:string"]
            ]
        }
        response = requests.post(f'{api_address}/devices/{data["sn"]}/tasks?connection_request', json=parameter)
        print(response.status_code)
        return response.status_code
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
        return 500

def gantissidpw(data, ssid, pw):
    print("acsss:", data["sn"])
    try:
        parameter = {
            "name": "setParameterValues",
            "parameterValues": [
                [f"Device.WiFi.SSID.1.SSID.{ssid_Ke}.SSID", ssid, "xsd:string"],
                [f"Device.WiFi.AccessPoint.1.Security.KeyPassphrase.{ssid_Ke}.PreSharedKey.1.PreSharedKey", pw, "xsd:string"]
            ]
        }
        response = requests.post(f'{api_address}/devices/{data["sn"]}/tasks?connection_request', json=parameter)
        print(response.status_code)
        return response.status_code
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
        return 500
